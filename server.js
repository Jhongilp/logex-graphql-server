import fs from "fs";
import { ApolloServer, gql } from "apollo-server-express";
import express from "express";
import pkg from "@prisma/client";
const { PrismaClient } = pkg;

// to add subscription support througt WS
import { createServer } from "http";
import { execute, subscribe } from "graphql";
import { SubscriptionServer } from "subscriptions-transport-ws";
import { makeExecutableSchema } from "@graphql-tools/schema";

//TODO use this logic to get the path
// fs.readFileSync(
//   path.join(__dirname, 'schema.graphql'),
//   'utf8'
// ),

const typeDefs = gql(
  fs.readFileSync("./src/graphql/schema.graphql", { encoding: "utf8" })
);

import resolvers from "./src/graphql/resolvers.js";

const prisma = new PrismaClient();

(async function startApolloServer() {
  const app = express();
  const httpServer = createServer(app);

  const schema = makeExecutableSchema({
    typeDefs,
    resolvers,
  });

  const server = new ApolloServer({
    schema,
    context: { prisma }
  });

  await server.start();

  server.applyMiddleware({
    app,
    path: "/",
  });

  const subscriptionServer = SubscriptionServer.create(
    { schema, execute, subscribe },
    { server: httpServer, path: server.graphqlPath }
  );

  // Shut down in the case of interrupt and termination signals
  // We expect to handle this more cleanly in the future. See (#5074)[https://github.com/apollographql/apollo-server/issues/5074] for reference.
  ["SIGINT", "SIGTERM"].forEach((signal) => {
    process.on(signal, () => subscriptionServer.close());
  });

  const PORT = 9000;
  httpServer.listen(PORT, () =>
    console.log(`Server is now running on http://localhost:${PORT}/`)
  );
})()
