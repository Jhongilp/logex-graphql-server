const { ApolloServer, gql } = require("apollo-server");

const typeDefs = gql`
  type Query {
    greeting: String
  }
`;

const resolvers = {
  Query: {
    greeting: () => "Hello GraphQL world!",
  },
};

const server = new ApolloServer({ typeDefs, resolvers });
server.listen({ port: 9000 }).then((serverInfo) => {
  console.log(`Apollo server running at: ${serverInfo.url}`);
});
