Quill = require 'quill'
Parchment = Quill.import 'parchment'

CustomClass = new Parchment.Attributor.Class('custom', 'ql-custom', scope: Parchment.Scope.INLINE)

Quill.register(CustomClass, true)
module.exports = CustomClass