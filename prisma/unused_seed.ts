
import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

async function main() {
  const expo1 = await prisma.export.create({
    data: {
      consecutivo: "1",
      customerId: "1",
      destinationCity: "Madrid",
      destinationCountry: "España",
      id: "1",
      globalProgress: 0,
      status: "Previo al cargue",
      transportMode: "SEA",
    }
  })
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
