// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(function(){

  $(window).ready(function(){
    $(".header-content").text("bbb");
  });  

  // $("#update_button").click( function() {
  //     $("#overlay").fadeIn();
  // });

  // $(window).load(function(){
  //   $(".header-content").text("bbb");
  // });

  // $(window).scroll( function(){    
  //     var st = $(window).scrollTop();
  //     $(".scroll_pos").text("縦位置:");
  //     if (st > 50)  {
  //       $("header").css('opacity','0.7');
  //     }  else  {
  //       $("header").css('opacity','1.0');
  //     }
  // });
};