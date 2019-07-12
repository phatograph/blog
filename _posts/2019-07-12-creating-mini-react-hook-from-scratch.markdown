---
layout: post
title: "Creating mini React's Hook from scratch"
tags:
- javascript
- react
- react-hook
---

### A simple `useState()`

Let's start with a simple `useState()` which does something like this;

<pre><code class="language-js">
const [count, countSet] = useState(0)
console.log(count())  // 0
countSet(1)
console.log(count())  // 1
</code></pre>

Here we can use a Closure to store a variable as a state.

<pre data-line="1-16"><code class="language-js">
const useState = (initialState) => {
  let state = initialState

  const getState = () => {
    return state
  }

  const setState = (newState) => {
    state = newState
  }

  return [
    getState,
    setState,
  ]
}

const [count, countSet] = useState(0)
console.log(count())  // 0
countSet(1)
console.log(count())  // 1
</code></pre>

### `React.useState()`

To mimic `React.useState()`, we can wrap out `useState()` in a `React` object
and it still works the same way.

<pre data-line="1,19-22,24"><code class="language-js">
const React = (() => {
  const useState = (initialState) => {
    let state = initialState

    const getState = () => {
      return state
    }

    const setState = (newState) => {
      state = newState
    }

    return [
      getState,
      setState,
    ]
  }

  return {
    useState,
  }
})()

const [count, countSet] = React.useState(0)
console.log(count())  // 0
countSet(1)
console.log(count())  // 1
</code></pre>

Since React renders a component, but we don't have `React.render()` yet.
So let's create a component first. 

<pre data-line="24-35,37-40"><code class="language-js">
const React = (() => {
  const useState = (initialState) => {
    let state = initialState

    const getState = () => {
      return state
    }

    const setState = (newState) => {
      state = newState
    }

    return [
      getState,
      setState,
    ]
  }

  return {
    useState,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)

  return {
    render: () => {
      console.log({count: count()})
    },
    click: () => {
      countSet(1)
    },
  }
}

const c = new Component()
c.render()  // {count: 0}
c.click()
c.render()  // {count: 1}
</code></pre>

This component also has `Component.render()`, which just logs the output in a console, rather than renders to the DOM.

Now we can implement `React.render()`, which creates a component, renders it, and also return the created component (so that we can do the action like `App.click`).

<pre data-line="19-23,27,44-47"><code class="language-js">
const React = (() => {
  const useState = (initialState) => {
    let state = initialState

    const getState = () => {
      return state
    }

    const setState = (newState) => {
      state = newState
    }

    return [
      getState,
      setState,
    ]
  }

  const render = (component) => {
    const c = component()
    c.render()
    return c
  }

  return {
    useState,
    render,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)

  return {
    render: () => {
      console.log({count: count()})
    },
    click: () => {
      countSet(1)
    },
  }
}

let App;
App = React.render(Component);  // {count: 0}
App.click()
App = React.render(Component);  // {count: 0}, whoa
</code></pre>

Now we have a problem. At line 47, it outputs `{count: 0}` instead of expected `{count: 1}`.

This happens because every time we call `React.render()`, a component will get newly created (`const c = component()`).
This behaviour is essentially what we call **re-rendering**. 

With a newly created component of each re-rendering, a local `state` in `React.useState()` is also created,
thus we lose the old `state`.

We can fix this problem by using a closure.

<pre data-line="2,5,8,12,45"><code class="language-js">
const React = (() => {
  let _state

  const useState = (initialState) => {
    let state = _state || initialState

    const setState = (newState) => {
      _state = newState
    }

    return [
      state,
      setState,
    ]
  }

  const render = (component) => {
    const c = component()
    c.render()
    return c
  }

  return {
    useState,
    render,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)

  return {
    render: () => {
      console.log({count})
    },
    click: () => {
      countSet(1)
    },
  }
}

let App;
App = React.render(Component);  // {count: 0}
App.click()
App = React.render(Component);  // {count: 1}, nice!
</code></pre>

By moving `state` within `React.useState()` to the outer level, namely `_state` (line 2).
We then create a closure by having a new `state` within `React.useState()` *closures* over `_state` (line 5).

So the first time `React.useState(0)` is called `_state` will be `undefined`,
so closured `state` will fallback to `initialState` (`undefined || 0`) and end up as `0`.

Now we can update the closured `state` properly, `App.click()` will change `_state` to `1`.
Then as the component re-renders, `React.useState(0)` will get called again, but this time
`_state` is `1` so the closured `state` will use `_state` value as `1`, it will not fallback to `initialState` (`1 || 0`).

Now that we have it work properly, let's change the click behaviour
to increase the count.

<pre data-line="37,46-49"><code class="language-js">
const React = (() => {
  let _state

  const useState = (initialState) => {
    let state = _state || initialState

    const setState = (newState) => {
      _state = newState
    }

    return [
      state,
      setState,
    ]
  }

  const render = (component) => {
    const c = component()
    c.render()
    return c
  }

  return {
    useState,
    render,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)

  return {
    render: () => {
      console.log({count})
    },
    click: () => {
      countSet(count + 1)
    },
  }
}

let App;
App = React.render(Component);  // {count: 0}
App.click()
App = React.render(Component);  // {count: 1}
App.click()
App = React.render(Component);  // {count: 2}
App.click()
App = React.render(Component);  // {count: 3}
</code></pre>

Let's see we now want another state in a component to hold a text
and name it `text`. We will output the text in a console and have
`Component.type()` to change it.

<pre data-line="31,35,40-42,47-55"><code class="language-js">
const React = (() => {
  let _state

  const useState = (initialState) => {
    let state = _state || initialState

    const setState = (newState) => {
      _state = newState
    }

    return [
      state,
      setState,
    ]
  }

  const render = (component) => {
    const c = component()
    c.render()
    return c
  }

  return {
    render,
    useState,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)
  const [text, textSet] = React.useState('a')

  return {
    render: () => {
      console.log({count, text})
    },
    click: () => {
      countSet(count + 1)
    },
    type: (x) => {
      textSet(x)
    },
  }
}

let App;
App = React.render(Component);  // {count: 0, text: "a"}
App.click()
App = React.render(Component);  // {count: 1, text: 1}, whoa
App.type('b')
App = React.render(Component);  // {count: "b", text: "b"}, whoaa
App.click()
App = React.render(Component);  // {count: "b1", text: "b1"}, whoaaa
App.click()
App = React.render(Component);  // {count: "b11", text: "b11"}, whoaaaa
</code></pre>

But it doesn't work as we expected (which means we expect that it will not work? Or it doesn't work as we expect? I wonder…).
Because `React` has only one `_state`, so it can hold only one state.

To fix this, we can store states in a `hooks` array, with an `index` to controll an access to it.
The `hooks` will start at `index=0`, so `0` from `count` will be stored at `index=0`,
and `a` from `text` will be stored at `index=1`. This works because every time `React.useState()` is called,
`index` will get incremented by 1.

<pre data-line="2-3,6,9,12,52-58"><code class="language-js">
const React = (() => {
  const hooks = []
  let index = 0

  const useState = (initialState) => {
    let state = hooks[index] || initialState

    const setState = (newState) => {
      hooks[index] = newState
    }

    index++

    return [
      state,
      setState,
    ]
  }

  const render = (component) => {
    const c = component()
    c.render()
    return c
  }

  return {
    render,
    useState,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)
  const [text, textSet] = React.useState('a')

  return {
    render: () => {
      console.log({count, text})
    },
    click: () => {
      countSet(count + 1)
    },
    type: (x) => {
      textSet(x)
    },
  }
}

let App;
App = React.render(Component);  // {count: 0, text: "a"}
App.click()
App = React.render(Component);  // {count: 1, text: "a"}, this is ok
App.type('b')
App = React.render(Component);  // {count: "b", text: "a"}, um, no
App.click()
App = React.render(Component);  // {count: "b1", text: "a"}, no
App.click()
App = React.render(Component);  // {count: "b11", text: "a"}, no
</code></pre>

Now we can store both states just fine (line 52), but as we try to set states, it doesn't work correctly.

This is quite subtle, as we said that `index` gets incremented constantly, the first time we call `React.render()`,
`React.useState()` gets called 2 times, thus `index` will increment from `0` to `2`.

Then we call `App.click()` which subsequently does `countSet(count + 1)`, count is `0` here so it will be
`countSet(1)`, given now `index` is `2`, it eventually resulting in `hooks[2] = 1`.

Now we have `hooks: [undefined, undefined, 1]`, which doesn't look like what we want. But let's continue anyway.

The second `React.render` calls `React.useState()` another 2 times, incrementing index from `2` to `4`.

Then we call `App.type('b')` which subsequently does `textSet('b')`,
given now `index: 4`, it eventually resulting in `hooks[4] = 'b'`.

Now we have `hooks: [undefined, undefined, 1, undefined, 'b']`.

The third `React.render` calls `React.useState()` another 2 times, incrementing `index` from `4` to `6`.

Then we call `App.click()` which subsequently does `countSet(count + 1)`.

But what is `count` here? It comes from the third re-rendering's `React.useState(0)`, by that time
`index=4` and given `let state = hooks[index] || initialState`, that is
`let state = hooks[4] || initialState`, which is `b`!

So we have `countSet('b' + 1)` which is `countSet('b1')`,
given now `index=`6`, it eventually resulting in `hooks[6] = 'b1'`.

Now we have;

<pre><code class="language-js">
hooks: [undefined, undefined, 1, undefined, 'b', undefined, 'b1']
</code></pre>

And so on.

Seems that we have a problem because `index` gets incremented constantly.
How about we reset it every time we re-render the component?

<pre data-line="21"><code class="language-js">
const React = (() => {
  const hooks = []
  let index = 0

  const useState = (initialState) => {
    let state = hooks[index] || initialState

    const setState = (newState) => {
      hooks[index] = newState
    }

    index++

    return [
      state,
      setState,
    ]
  }

  const render = (component) => {
    index = 0
    const c = component()
    c.render()
    return c
  }

  return {
    render,
    useState,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)
  const [text, textSet] = React.useState('a')

  return {
    render: () => {
      console.log({count, text})
    },
    click: () => {
      countSet(count + 1)
    },
    type: (x) => {
      textSet(x)
    },
  }
}

let App;
App = React.render(Component);  // {count: 0, text: "a"}
App.click()
App = React.render(Component);  // {count: 0, text: "a"}, whoa, it gets worse
App.type('b')
App = React.render(Component);  // {count: 0, text: "a"}
App.click()
App = React.render(Component);  // {count: 0, text: "a"}
App.click()
App = React.render(Component);  // {count: 0, text: "a"}
</code></pre>

The first `React.render()` calling to `React.useState()`s still increments `index` from `0` to `2`.
The first `App.click()` sets `hooks: [undefined, undefined, 1]`, okay, still ugly.

Now the second `React.render()` resets `index` to `0`. That means once `React.useState(0)` is called,
that means `let state = hooks[0] || initialState`, which is `let state = undefined || 0`.
So `count` here is `0`.

The same goes for `React.useState('a')` which gives
`let state = hooks[1] || initialState`, which is `let state = undefined || 'a'`. So `text` here is `a`.

Well now the `1` in `hooks: [undefined, undefined, 1]` doesn't even get used.
We managed to reset `index` all right, but the reference to a corresponding `index` of each `React.useState()` is lost.
We somehow need to keep tracking the `index` for each `React.useState()`.

[Closure](https://twitter.com/markdalgleish/status/1095025468367990784):

<img
  src="https://pbs.twimg.com/media/DzJP2rLWkAAgxku.jpg:large"
/>

<pre data-line="6,7,10,54,56,58,60"><code class="language-js">
const React = (() => {
  const hooks = []
  let index = 0

  const useState = (initialState) => {
    const _index = index
    let state = hooks[_index] || initialState

    const setState = (newState) => {
      hooks[_index] = newState
    }

    index++

    return [
      state,
      setState,
    ]
  }

  const render = (component) => {
    index = 0
    const c = component()
    c.render()
    return c
  }

  return {
    render,
    useState,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)
  const [text, textSet] = React.useState('a')

  return {
    render: () => {
      console.log({count, text})
    },
    click: () => {
      countSet(count + 1)
    },
    type: (x) => {
      textSet(x)
    },
  }
}

let App;
App = React.render(Component);  // {count: 0, text: "a"}
App.click()
App = React.render(Component);  // {count: 1, text: "a"}, yes!
App.type('b')
App = React.render(Component);  // {count: 1, text: "b"}, yes!
App.click()
App = React.render(Component);  // {count: 2, text: "b"}
App.click()
App = React.render(Component);  // {count: 3, text: "b"}
</code></pre>

Now let's see, the first `React.render()` calling to `React.useState()`s increments `index` from `0` to `2` as usual,
but now each save its own `_index`, so `_index: 0` for `count` and `_index: 1` for `text`.

And here comes `App.click()`, calling `countSet(0 + 1)` which then is `hooks[_index] = 1`, which is `hooks[0] = 1`.

So now `hooks: [1]`, looking good!

The second `React.render()` then reset `index` to `0`. 

Then its calling to `React.useState(0)` which does 
`const _index = index`, which is `const _index = 0`, still results in `_index: 0` for `count`.
Then it does `let state = hooks[_index] || initialState`, which is `let state = hooks[0] || 0`,
which is `let state = 1 || 0`, we then have `count` as `1`!

While `React.useState('a')` will have `_index: 1` and while it does `let state = hooks[1] || 'a'`,
which is `let state = undefined || 'a'`, we still have `text` as `a`.

Then comes `App.type('b')`, calling `textSet('b')` which then is `hooks[_index] = 'b'`, which is `hooks[1] = 'b'`

So now `hooks: [1, 'b']`, aye, this is what we're looking for.

The third `React.render()` then reset `index` to `0`. 

`React.useState(0)` having `_index: 0` will look for
`let state = hooks[0] || 0`, which is `let state = 1 || 0`, so `count` is `1`.

While `React.useState('a')` having `_index: 1` will look for
`let state = hooks[1] || 0`, which is `let state = 'b' || 'a'`, so `text` is `b`.

Then comes another `App.click()`, calling `countSet(1 + 1)` which then is `hooks[_index] = 2`, which is `hooks[0] = 2`

So now `hooks: [2, 'b']`.

The third `React.render()` then reset `index` to `0`. `React.useState(0)` having `_index: 0` will look for
`let state = hooks[0] || 0`, which is `let state = 2 || 0`, so `count` is `2`.

Now `React.useState()` works exactly what we expected!

### `React.useEffect()`

TBD

<pre data-line="21-23,34,43-45,61-83"><code class="language-js">
const React = (() => {
  const hooks = []
  let index = 0

  const useState = (initialState) => {
    const _index = index
    let state = hooks[_index] || initialState

    const setState = (newState) => {
      hooks[_index] = newState
    }

    index++

    return [
      state,
      setState,
    ]
  }

  const useEffect = (callback) => {
    callback()
  }

  const render = (component) => {
    index = 0
    const c = component()
    c.render()
    return c
  }

  return {
    useState,
    useEffect,
    render,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)
  const [text, textSet] = React.useState('a')

  React.useEffect(() => {
    console.log('useEffect triggered');
  });

  return {
    render: () => {
      console.log({count, text})
    },
    click: () => {
      countSet(count + 1)
    },
    type: (x) => {
      textSet(x)
    },
  }
}

let App;
App = React.render(Component);
// useEffect triggered 
// {count: 0, text: "a"}

App.click()
App = React.render(Component);
// useEffect triggered 
// {count: 1, text: "a"}

App.type('b')
App = React.render(Component);
// useEffect triggered 
// {count: 1, text: "b"}

App.click()
App = React.render(Component);
// useEffect triggered 
// {count: 2, text: "b"}

App.click()
App = React.render(Component);
// useEffect triggered 
// {count: 3, text: "b"}
</code></pre>

TBD

<pre data-line="21-24,46"><code class="language-js">
const React = (() => {
  const hooks = []
  let index = 0

  const useState = (initialState) => {
    const _index = index
    let state = hooks[_index] || initialState

    const setState = (newState) => {
      hooks[_index] = newState
    }

    index++

    return [
      state,
      setState,
    ]
  }

  const useEffect = (callback, depArray) => {
    let hasChanged = true
    if (hasChanged) callback()
  }

  const render = (component) => {
    index = 0
    const c = component()
    c.render()
    return c
  }

  return {
    useState,
    useEffect,
    render,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)
  const [text, textSet] = React.useState('a')

  React.useEffect(() => {
    console.log('useEffect triggered');
  }, [count]);

  return {
    render: () => {
      console.log({count, text})
    },
    click: () => {
      countSet(count + 1)
    },
    type: (x) => {
      textSet(x)
    },
  }
}

let App;
App = React.render(Component);
// useEffect triggered 
// {count: 0, text: "a"}

App.click()
App = React.render(Component);
// useEffect triggered 
// {count: 1, text: "a"}

App.type('b')
App = React.render(Component);
// useEffect triggered 
// {count: 1, text: "b"}

App.click()
App = React.render(Component);
// useEffect triggered 
// {count: 2, text: "b"}

App.click()
App = React.render(Component);
// useEffect triggered 
// {count: 3, text: "b"}
</code></pre>

TBD

<pre data-line="22,27-28"><code class="language-js">
const React = (() => {
  const hooks = []
  let index = 0

  const useState = (initialState) => {
    const _index = index
    let state = hooks[_index] || initialState

    const setState = (newState) => {
      hooks[_index] = newState
    }

    index++

    return [
      state,
      setState,
    ]
  }

  const useEffect = (callback, depArray) => {
    const oldDeps = hooks[index]
    let hasChanged = true

    if (hasChanged) callback()
    
    hooks[index] = depArray
    index++
  }

  const render = (component) => {
    index = 0
    const c = component()
    c.render()
    return c
  }

  return {
    useState,
    useEffect,
    render,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)
  const [text, textSet] = React.useState('a')

  React.useEffect(() => {
    console.log('useEffect triggered');
  }, [count]);

  return {
    render: () => {
      console.log({count, text})
    },
    click: () => {
      countSet(count + 1)
    },
    type: (x) => {
      textSet(x)
    },
  }
}

let App;
App = React.render(Component);
// useEffect triggered 
// {count: 0, text: "a"}

App.click()
App = React.render(Component);
// useEffect triggered 
// {count: 1, text: "a"}

App.type('b')
App = React.render(Component);
// useEffect triggered 
// {count: 1, text: "b"}

App.click()
App = React.render(Component);
// useEffect triggered 
// {count: 2, text: "b"}

App.click()
App = React.render(Component);
// useEffect triggered 
// {count: 3, text: "b"}
</code></pre>

TBD

<pre data-line="25-29,74,80,86,91,97"><code class="language-js">
const React = (() => {
  const hooks = []
  let index = 0

  const useState = (initialState) => {
    const _index = index
    let state = hooks[_index] || initialState

    const setState = (newState) => {
      hooks[_index] = newState
    }

    index++

    return [
      state,
      setState,
    ]
  }

  const useEffect = (callback, depArray) => {
    const oldDeps = hooks[index]
    let hasChanged = true

    console.log('useEffect: ', oldDeps, depArray)

    if (oldDeps) {
      hasChanged = depArray.some((x, i) => x != oldDeps[i])
    }

    if (hasChanged) callback()

    hooks[index] = depArray
    index++
  }

  const render = (component) => {
    index = 0
    const c = component()
    c.render()
    return c
  }

  return {
    useState,
    useEffect,
    render,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)
  const [text, textSet] = React.useState('a')

  React.useEffect(() => {
    console.log('useEffect triggered');
  }, [count]);

  return {
    render: () => {
      console.log({count, text})
    },
    click: () => {
      countSet(count + 1)
    },
    type: (x) => {
      textSet(x)
    },
  }
}

let App;
App = React.render(Component);
// useEffect: undefined [0]
// useEffect triggered 
// {count: 0, text: "a"}

App.click()
App = React.render(Component);
// useEffect: [0] [1]
// useEffect triggered 
// {count: 1, text: "a"}

App.type('b')
App = React.render(Component);
// useEffect: [1] [1], here useEffect won't be triggered
// {count: 1, text: "b"}

App.click()
App = React.render(Component);
// useEffect: [1] [2]
// useEffect triggered 
// {count: 2, text: "b"}

App.click()
App = React.render(Component);
// useEffect: [2] [3]
// useEffect triggered 
// {count: 3, text: "b"}
</code></pre>

TBD

<pre data-line="57,74,80,86-87,92,98,101-106"><code class="language-js">
const React = (() => {
  const hooks = []
  let index = 0

  const useState = (initialState) => {
    const _index = index
    let state = hooks[_index] || initialState

    const setState = (newState) => {
      hooks[_index] = newState
    }

    index++

    return [
      state,
      setState,
    ]
  }

  const useEffect = (callback, depArray) => {
    const oldDeps = hooks[index]
    let hasChanged = true

    console.log('useEffect: ', oldDeps, depArray)

    if (oldDeps) {
      hasChanged = depArray.some((x, i) => x != oldDeps[i])
    }

    if (hasChanged) callback()

    hooks[index] = depArray
    index++
  }

  const render = (component) => {
    index = 0
    const c = component()
    c.render()
    return c
  }

  return {
    useState,
    useEffect,
    render,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)
  const [text, textSet] = React.useState('a')

  React.useEffect(() => {
    console.log('useEffect triggered');
  }, [count, text]);

  return {
    render: () => {
      console.log({count, text})
    },
    click: () => {
      countSet(count + 1)
    },
    type: (x) => {
      textSet(x)
    },
  }
}

let App;
App = React.render(Component);
// useEffect: undefined [0, 'a']
// useEffect triggered 
// {count: 0, text: "a"}

App.click()
App = React.render(Component);
// useEffect: [0, 'a'] [1, 'a']
// useEffect triggered 
// {count: 1, text: "a"}

App.type('b')
App = React.render(Component);
// useEffect: [1, 'a'] [1, 'b']
// useEffect triggered, here useEffect will once again triggered
// {count: 1, text: "b"}

App.click()
App = React.render(Component);
// useEffect: [1, 'b'] [2, 'b']
// useEffect triggered 
// {count: 2, text: "b"}

App.click()
App = React.render(Component);
// useEffect: [2, 'b'] [3, 'b']
// useEffect triggered 
// {count: 3, text: "b"}

App.type('c')
App = React.render(Component);
// useEffect: [3, 'b'] [3, 'c']
// useEffect triggered 
// {count: 3, text: "c"}
</code></pre>

TBD

<pre data-line="57,74,80,86"><code class="language-js">
const React = (() => {
  const hooks = []
  let index = 0

  const useState = (initialState) => {
    const _index = index
    let state = hooks[_index] || initialState

    const setState = (newState) => {
      hooks[_index] = newState
    }

    index++

    return [
      state,
      setState,
    ]
  }

  const useEffect = (callback, depArray) => {
    const oldDeps = hooks[index]
    let hasChanged = true

    console.log('useEffect: ', oldDeps, depArray)

    if (oldDeps) {
      hasChanged = depArray.some((x, i) => x != oldDeps[i])
    }

    if (hasChanged) callback()

    hooks[index] = depArray
    index++
  }

  const render = (component) => {
    index = 0
    const c = component()
    c.render()
    return c
  }

  return {
    useState,
    useEffect,
    render,
  }
})()

const Component = () => {
  const [count, countSet] = React.useState(0)
  const [text, textSet] = React.useState('a')

  React.useEffect(() => {
    console.log('useEffect triggered');
  }, [text, count]);

  return {
    render: () => {
      console.log({count, text})
    },
    click: () => {
      countSet(count + 1)
    },
    type: (x) => {
      textSet(x)
    },
  }
}

let App;
App = React.render(Component);
// useEffect: undefined ["a", 0]
// useEffect triggered 
// {count: 0, text: "a"}

App.click()
App = React.render(Component);
// useEffect: ["a", 0] ["a", 1]
// useEffect triggered 
// {count: 1, text: "a"}

App.type('b')
App = React.render(Component);
// useEffect: ['a', 1] ['b', 1]
// useEffect triggered
// {count: 1, text: "b"}
</code></pre>

TBD
