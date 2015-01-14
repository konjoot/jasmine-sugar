tests = []

for file of window.__karma__.files
  if window.__karma__.files.hasOwnProperty file
    if /Spec\.js$/.test file
      tests.push file

requirejs.config
    baseUrl: '/base/src'

    paths:
      SharedExamples: '../test/sharedExamples'

    deps: tests

    callback: window.__karma__.start
