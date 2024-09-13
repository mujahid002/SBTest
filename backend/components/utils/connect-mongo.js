require("dotenv").config();
const { MongoClient, ServerApiVersion } = require("mongodb");
const uri = "mongodb+srv://muja002:muja@knowledge.fyfvm7c.mongodb.net/";
// const uri = `mongodb://${process.env.MONGO_DB_UNAME}:${process.env.MONGO_DB_PASS}@${process.env.MONGO_DB_SERVER_IP}:${process.env.MONGO_DB_PORT}/?retryWrites=true&w=majority`;

// Create a MongoClient with a MongoClientOptions object to set the Stable API version
const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  },
});
async function connectMongo() {
  try {
    // Connect the client to the server	(optional starting in v4.7)
    await client.connect();
    // Send a ping to confirm a successful connection
    await client.db("admin").command({ ping: 1 });
    console.log(
      "Pinged your deployment. You successfully connected to MongoDB!"
    );

    return client;
  } catch (err) {
    console.log(err);
    await client.close();
    throw err;
  }
}

module.exports = connectMongo;
// console.log(process.env.MONGO_DB_PASS);
