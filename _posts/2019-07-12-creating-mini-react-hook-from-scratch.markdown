---
layout: post
title: "Creating mini React's Hook from scratch"
tags:
- javascript
- react
- react-hook
---

Miraculous the israelites did cross there in the place was burned down melting the marrow. Of a profoundly grave.

<pre>
  <code class="language-js">
const React = (() => {
  const hooks = []
  let index = 0

  const useState = (initVal) => {
    const _index = index
    const state = hooks[index] || initVal

    const setState = (newVal) => {
      hooks[_index] = newVal
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

    console.log('useEffect', hooks, index, oldDeps, depArray)

    if (oldDeps) {
      hasChanged = depArray.some((x, i) => x != oldDeps[i])
    }

    if (hasChanged) callback()

    hooks[index] = depArray
    index++
  }

  const render = (component) => {
    index = 0
    //console.log('React.render', hooks)
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
  const [count, countSet] = React.useState(1)
  const [text, textSet] = React.useState('a')

  React.useEffect(() => {
    console.log('useEffect triggered')
  }, [text, count])

  return {
    render: () => {
      console.log('Component.render', {count})
      console.log()
    },
    click: () => {
      console.log('click')
      countSet(count + 1)
    },
    type: (x) => {
      console.log('type')
      textSet(x)
    },
  }
}

let App
App = React.render(Component)
App.click()
App = React.render(Component)
App.type('b')
App = React.render(Component)
App.click()
App = React.render(Component)
App.click()
App = React.render(Component)
  </code>
</pre>

Land in the ice in english history our little column nothing could for.
