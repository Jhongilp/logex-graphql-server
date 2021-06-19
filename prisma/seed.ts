import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

async function main() {
  const user = await prisma.user.create({
    data: {
      email: "jhongilp@gmail.com",
      fisrtName: "Jonathan",
      lastName: "Gil",
      social: {
        twitter: "jhongilp",
      },
    },
  });

  const course = await prisma.course.create({
    data: {
      name: "Intro to Prisma",
      courseDetails: "Learning to use Prisma with Postgres",
      tests: {
        create: [
          {
            date: new Date(),
            name: "First test",
          },
          {
            date: new Date(),
            name: "Second test",
          },
          {
            date: new Date(),
            name: "Final test",
          },
        ],
      },
      members: {
        create: {
          role: "STUDENT",
          user: {
            connect: { email: user.email },
          },
        },
      },
    },
    include: {
      tests: true,
      members: {
        include: { user: true },
      },
    },
  });

  const user2 = await prisma.user.create({
    data: {
      email: "linheros@gmail.com",
      fisrtName: "Linda",
      lastName: "Hernandez",
      social: {
        twitter: "linehros",
      },
      courses: {
        create: {
          role: "TEACHER",
          course: {
            connect: { id: course.id },
          },
        },
      },
    },
  });

  const testResults = [800, 950, 700];

  course.tests.forEach(async (test, i) => {
    const user1ResultTest = await prisma.testResult.create({
      data: {
        gradedBy: { connect: { email: user2.email } },
        student: { connect: { email: user.email } },
        test: { connect: { id: course.tests[0]?.id } },
        result: testResults[i],
      },
    });
  });

  const results = await prisma.testResult.aggregate({
    where: { studentId: user.id },
    _avg: { result: true },
    _max: { result: true },
    _min: { result: true },
    _count: true,
  });
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
