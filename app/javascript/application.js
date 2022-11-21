// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as jq from 'jquery';
window.importmapScriptsLoaded = true;

$(function(){
    console.log('Jquery is working')
})
