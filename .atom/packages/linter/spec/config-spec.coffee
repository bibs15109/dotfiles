describe 'Linter Config', ->
  linter = null
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('linter').then ->
        linter = atom.packages.getActivePackage('linter').mainModule.instance

  getLinter = ->
    return {grammarScopes: ['*'], lintOnFly: false, modifiesBuffer: false, scope: 'project', lint: -> }
  getMessage = (type, filePath) ->
    return {type, text: "Some Message", filePath}
  nextAnimationFrame = ->
    return new Promise (resolve) -> requestAnimationFrame(resolve)

  describe 'ignoredMessageTypes', ->
    it 'ignores certain types of messages', ->
      linterProvider = getLinter()
      expect(linter.messages.publicMessages.length).toBe(0)
      linter.messages.set({linter: linterProvider, messages: [getMessage('Error'), getMessage('Warning')]})
      waitsForPromise ->
        nextAnimationFrame().then( ->
          expect(linter.messages.publicMessages.length).toBe(2)
          atom.config.set('linter.ignoredMessageTypes', ['Error'])
          linter.messages.set({linter: linterProvider, messages: [getMessage('Error'), getMessage('Warning')]})
          return nextAnimationFrame()
        ).then ->
          expect(linter.messages.publicMessages.length).toBe(1)

  describe 'statusIconScope', ->
    it 'only shows messages of the current scope', ->
      linterProvider = getLinter()
      expect(linter.views.bottomContainer.status.count).toBe(0)
      linter.messages.set({linter: linterProvider, messages: [getMessage('Error', '/tmp/test.coffee')]})
      waitsForPromise ->
        nextAnimationFrame().then( ->
          expect(linter.views.bottomContainer.status.count).toBe(1)
          atom.config.set('linter.statusIconScope', 'File')
          expect(linter.views.bottomContainer.status.count).toBe(0)
          atom.config.set('linter.statusIconScope', 'Project')
          expect(linter.views.bottomContainer.status.count).toBe(1)
        )
