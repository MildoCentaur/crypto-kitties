// var path = require('path');
// app.use('/scripts', express.static(path.join(__dirname, 'node_modules/bootstrap/dist')));

const web3 = new Web3(Web3.givenProvider)
var instance;
var user;
var contractAddress = "0xa9EF02C070994aE722Dd0D7b36D762f12f3be3cF";

$(document).ready(function(){
    window.ethereum.enable().then(function(accounts){
        user = accounts[0];
        console.log(user);
        instance = new web3.eth.Contract(abi, contractAddress, {from: user})
        console.log(instance);
        
        instance.events.Birth().on('data', function(event){
            console.log(event);
            let owner = event.returnValues.owner;
            let kittenId = event.returnValues.kittenId;
            let mumId = event.returnValues.mumId;
            let dadId = event.returnValues.dadId;
            let genes = event.returnValues.genes
            $("#kittyCreation").css("display", "block");
            $("#kittyCreation").text("owner:" + owner
                                    +" kittyId:" + kittenId
                                    +" mumId:" + mumId
                                    +" dadId:" + dadId
                                    +" genes:" + genes)
        })
        .on('error', console.error);
        
        
        
    });  
    
    $("#createKitty").click(async function(){
        let dna = $("#dnabody").text();
        dna = dna + $("#dnamouth").text();
        dna = dna + $("#dnaeyes").text();
        dna = dna + $("#dnaears").text();
        dna = dna + $("#dnashape").text();
        dna = dna + $("#dnadecoration").text();
        dna = dna + $("#dnadecorationMid").text();
        dna = dna + $("#dnadecorationSides").text();
        dna = dna + $("#dnaanimation").text();
        dna = dna + $("#dnaspecial").text();
        instance.methods.createKittyGen0(dna).send({from:"0x92DCED20aD7a069a9d929e09A78E5Ed744040f3A"})
        .on('transactionHash', function(hash){
            console.log('transactionHash');
            console.log(hash);
        })
        .on('receipt', function(receipt){
            // receipt example
            console.log('receipt');
            console.log(receipt.events['Birth']);
            console.log(receipt.events['Transfer']);          
        }).on('error', function(error, receipt) { // If the transaction was rejected by the network with a receipt, the second parameter will be the receipt.
            console.log('error');
            console.log(`code: ${error.code}`);
            console.log(`message: ${error.message}`);
            console.log(error);
        });

        instance.methods.gen0Counter().call().then(function(result){
            console.log(result);
        });
        // let dna = $("#dnabody").text();
        //     dna = dna + $("#dnamouth").text();
        //     dna = dna + $("#dnaeyes").text();
        //     dna = dna + $("#dnaears").text();
        //     dna = dna + $("#dnashape").text();
        //     dna = dna + $("#dnadecoration").text();
        //     dna = dna + $("#dnadecorationMid").text();
        //     dna = dna + $("#dnadecorationSides").text();
        //     dna = dna + $("#dnaanimation").text();
        //     dna = dna + $("#dnaspecial").text();
        // console.log(dna);
        // No puedo capturar los eventos por separado!! 
        // await instance.methods.createKittyGen0().send()
        // .on('transactionHash', function(hash){
        //     console.log('transactionHash');
        //     console.log(hash);
        // })
        // .on('receipt', function(receipt){
        //     // receipt example
        //     console.log('receipt');
        //     console.log(receipt.events['Birth']);
        //     console.log(receipt.events['Transfer']);          
        // })
        
        
        // instance.methods.createKittyGen0().send()
        // .on('data', function(event){
        //     console.log(event)
        //     console.log("En el bopton")
        
    });
})
