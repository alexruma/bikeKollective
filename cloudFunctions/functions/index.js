const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { firestore } = require("firebase-admin");
admin.initializeApp();




exports.scheduleFunction = functions.pubsub.schedule('every 10 minutes').onRun(async (context)=>{
// const bikesRef = db.collection('bikes');
console.log("running");
var snapshot = await admin.firestore().collection('bikes').orderBy('checkoutTime').get();


snapshot.forEach(async doc=> {
    // Get checkout Time and if greater than
    curr_doc = doc.data();
    curr_time = curr_doc['checkoutTime'].toMillis() ;
    time_con = 28800000 // Time constraint in milliseconds 8 hrs

    if(curr_time + time_con < Date.now()){
        console.log('Found late time. Bike ID:' + doc.id)
        //Find data and update
        var user = admin.firestore().collection('users').doc(curr_doc['cur_user'])
        
        var userdata =await user.get();
            if (!userdata.exists){
                console.log("User doesn't exist")
            } else{
                user.update({
                    'banned': true,
                    'bikeCheckedOut':"",
                })
                console.log("User banned: " + userdata.data()['first'] + " " + userdata.data()['last']);
            }
        bikedata =admin.firestore().collection('bikes').doc(doc.id)
        bikedata.update({
            'checkoutTime': firestore.FieldValue.delete(),
            'cur_user':"",
            'stolen': true,
            'available': false
        })

    }
    console.log(doc.id, '=>', doc.data()['cur_user']);
});

});
