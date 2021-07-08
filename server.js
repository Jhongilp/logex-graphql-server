const fs = require("fs");
const { ApolloServer, gql } = require("apollo-server");
const { PrismaClient } = require("@prisma/client");

//TODO use this logic to get the path
// fs.readFileSync(
//   path.join(__dirname, 'schema.graphql'),
//   'utf8'
// ),

const typeDefs = gql(
  fs.readFileSync("./src/graphql/schema.graphql", { encoding: "utf8" })
);
const resolvers = require("./src/graphql/resolvers");

const prisma = new PrismaClient();

const server = new ApolloServer({ typeDefs, resolvers, context: { prisma } });
server.listen({ port: 9000 }).then((serverInfo) => {
  console.log(`Apollo server running at: ${serverInfo.url}`);
});
