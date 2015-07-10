(function() {
    var app = angular.module('bot', []);

    app.controller('BotController', ['$scope', '$http', '$sce',
        function($scope, $http, $sce) {

            $scope.getReply = function() {
                $scope.progress = 'handling... plz wait...';
                $scope.reply = {};

                $http({
                    headers: {},
                    method: 'GET',
                    url: '/api/reply?question=' + $scope.question,                    
                }).
                success(function(data, status, headers, config) {
                    $scope.progress = '';
                    data.youtube_embed_url = $sce.trustAsResourceUrl(data.youtube_embed_url);
                    $scope.reply = data;
                }).
                error(function(data, status, headers, config) {
                    $scope.progress = 'fail';
                });
            };

            ZeroClipboard.config({
                swfPath: "//cdnjs.cloudflare.com/ajax/libs/zeroclipboard/2.1.3/ZeroClipboard.swf"
            });
            var client = new ZeroClipboard(document.getElementById("copy-button"));
            client.on("ready", function(readyEvent) {
                // alert("ZeroClipboard SWF is ready!");
                client.on('copy', function(event) {
                    // event.clipboardData.setData('text/plain', event.target.innerHTML);
                    // event.clipboardData.setData('text/plain', $scope.replys);
                    event.clipboardData.setData('text/plain', 'Me: '+$scope.question + '\nMiro: ' + $scope.reply.sentence + '\n' + $scope.reply.youtube_url);
                });

                client.on("aftercopy", function(event) {
                    // `this` === `client`
                    // `event.target` === the element that was clicked
                    // event.target.style.display = "none";
                    // alert("Copied text to clipboard: " + event.data["text/plain"]);                    
                    alert('Copied~!\n\nMe: ' + $scope.question + '\nMiro: ' + $scope.reply.sentence + '\n' + $scope.reply.youtube_url);
                });
            });
            client.on('error', function() {
                alert("zeroclipboard swf load error");
                ZeroClipboard.destroy();
            });

        }
    ]);

})();