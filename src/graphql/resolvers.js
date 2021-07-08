const { GraphQLScalarType, Kind } = require("graphql");
const { v4: uuidv4 } = require("uuid");

const dateScalar = new GraphQLScalarType({
  name: "Date",
  description: "Date custom scalar type",
  serialize(value) {
    console.log("serialize: ", value);
    return value.getTime(); // Convert outgoing Date to integer for JSON
  },
  parseValue(value) {
    console.log("parseValue: ", value);
    return new Date(value); // Convert incoming integer to Date
  },
  parseLiteral(ast) {
    if (ast.kind === Kind.INT) {
      return new Date(parseInt(ast.value, 10)); // Convert hard-coded AST string to integer and then to Date
    }
    return null; // Invalid hard-coded value (not an integer)
  },
});

const Query = {
  expos: async (_root, _args, { prisma }) => {
    const expo = await prisma.export.findMany();
    console.log("expo query result: ", expo);
    return expo;
  },
  customers: async (_root, _args, { prisma }) => {
    return prisma.customer.findMany();
  },
};

const Expo = {
  customer: (parent, _args, { prisma }) => {
    console.log("[expo > customer ] parent: ", parent);
    return prisma.customer.findUnique({ where: { id: parent.customerId } });
  },
};

const Mutation = {
  createExpo: async (_root, args, { prisma }) => {
    console.log("[create expo] args: ", args);
    const { consecutivo, customerId, transportMode } = args.input;
    const expo = await prisma.export.create({
      data: {
        id: uuidv4(),
        consecutivo,
        customerId,
        transportMode,
        status: "Previo al cargue",
        globalProgress: 0,
      },
    });
    return expo;
  },

  createCustomer: async (_root, args, { prisma }) => {
    const { name, country, city, address } = args.input;
    console.log("[create customer] args input: ", args.input);
    const customer = await prisma.customer.create({
      data: {
        id: uuidv4(),
        name,
        country,
        city,
        address,
      },
    });
    return customer;
  },
};

module.exports = {
  Date: dateScalar,
  Query,
  Mutation,
  Expo,
};
