const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')
const customConfig = require('./custom')

environment.config.merge(customConfig)

environment.loaders.append('vue', vue)

module.exports = environment
