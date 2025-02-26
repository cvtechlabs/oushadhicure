const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();
const port = 3000;

app.use(bodyParser.json());


mongoose.connect('mongodb+srv://techlabscv:3KXMTmXsGVHATo5w@cluster0.fvkzl.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
const db = mongoose.connection;
db.on('error', (error) => console.error(error));
db.once('open', () => console.log('Connected to Database'));


// app.delete('/:id', async (req, res) => {
//   const id = req.params.id;
//  await User.findByIdAndDelete(id);
//   res.json('Delete successfully');
// });

// //TODO:  this

app.post('/', (req, res) => {
  const {name, age, email} = req.body
  const newUser = new User({name:name, age:age, email:email});
  newUser.save();
  res.json('api is working');
 });

 app.put('/:id', async (req, res) => {
  const id  = req.params.id;
  await User.findByIdAndUpdate(id, { $set: {name:"new name", age: 31 } }, { new: true });  
  res.json('Update succesfully');
 });

 app.delete('/:id', async (req, res) => {
  const id  = req.params.id;
  await User.findByIdAndDelete(id);  
  res.json('Delete succesfully');
 });

app.get('/get', async (req, res) => {
  const users = await User.find()
  res.json(users);
 });

app.listen(port, () => {
  console.log(`Server is running on :${port}`);
});



const { Schema, model } = mongoose;
const userSchema = new Schema({
  name: String,
  age: Number,
  email: String
});
const User = model('User', userSchema);