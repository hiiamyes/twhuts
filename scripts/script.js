var client = new Dropbox.Client({
    key: 'ydspoohcpyj0lyo'
});


client.authenticate(function(error, client) {
    if (error) {
        // Replace with a call to your own error-handling code.
        //
        // Don't forget to return from the callback, so you don't execute the code
        // that assumes everything went well.
        console.log(error);
    }

    // Replace with a call to your own application code.
    //
    // The user authorized your app, and everything went well.
    // client is a Dropbox.Client instance that you can use to make API calls.
    console.log('gg');
});
