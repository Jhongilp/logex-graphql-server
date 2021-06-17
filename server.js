const fs = require("fs");
const { ApolloServer, gql } = require("apollo-server");

const typeDefs = gql(fs.readFileSync("./src/graphql/schema.graphql", { encoding: "utf8" }));
const resolvers = require('./src/graphql/resolvers');


const server = new ApolloServer({ typeDefs, resolvers });
server.listen({ port: 9000 }).then((serverInfo) => {
  console.log(`Apollo server running at: ${serverInfo.url}`);
});
