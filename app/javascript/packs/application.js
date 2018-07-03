/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Vue from 'vue'
import ApiTest from './api_test.vue'

Vue.component("api-test", ApiTest)

window.vbus = new Vue()
window.$vue_data = {}
window.Vue = Vue

document.addEventListener('DOMContentLoaded', () => {
  new Vue({ el: '#vue_root', data: window.$vue_data })
})

