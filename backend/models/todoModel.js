const mongoose = require('mongoose');

const todoSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId,
     required: true,
     ref: 'User' },

  title: { type: String, required: true },
  description: { type: String },
  completed: { type: Boolean, default: false },
},

{
    
timestamps: true
}
);
module.exports = mongoose.model('Todo', todoSchema);