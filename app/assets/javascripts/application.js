// This is a manifest file that’ll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin’s
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It’s not advisable to add code directly here, but if you do, it’ll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require will_paginate_infinite
//= require_tree .

$(document).on('turbolinks:load', function() {
  $('.advance-form-btn').on('click', function() {
    const isExpanded = $('.advance-form').hasClass('expanded')
    if (isExpanded) {
      $('.advance-form').removeClass('expanded')
      $('.advance-form-icon').removeClass('fa-angle-double-up')
      $('.advance-form-icon').addClass('fa-angle-double-down')
      $('.advance-form input').each(function(index, input) {
        input.value = null
      })
    } else {
      $('.advance-form').addClass('expanded')
      $('.advance-form-icon').removeClass('fa-angle-double-down')
      $('.advance-form-icon').addClass('fa-angle-double-up')
    }
  })

  $('.tab-link').on('click', function() {
    const name = this.dataset.tabname
    $('.tab-link.active').removeClass('active')
    $(this).addClass('active')
    $(`.tab-contents .active`).removeClass('active')
    $(`.tab-contents #tab-${name}`).addClass('active')
  })
})