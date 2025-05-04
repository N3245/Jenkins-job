// script.js
var app = angular.module('serviceManagementApp', []);

app.controller('ServiceController', function($scope) {
    $scope.formData = {}; // Initialize form data

    $scope.save = function() {
        // Handle save logic here (e.g., send data to server)
        console.log("Saving data:", $scope.formData);
    };

    $scope.cancel = function() {
        // Handle cancel logic here (e.g., reset the form)
        console.log("Cancelling");
        $scope.formData = {}; // Reset form data
    };
});