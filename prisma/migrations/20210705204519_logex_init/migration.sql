/*
  Warnings:

  - You are about to drop the `Course` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `CourseEnrollment` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Test` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `TestResult` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "CourseEnrollment" DROP CONSTRAINT "CourseEnrollment_courseId_fkey";

-- DropForeignKey
ALTER TABLE "CourseEnrollment" DROP CONSTRAINT "CourseEnrollment_userId_fkey";

-- DropForeignKey
ALTER TABLE "Test" DROP CONSTRAINT "Test_courseId_fkey";

-- DropForeignKey
ALTER TABLE "TestResult" DROP CONSTRAINT "TestResult_graderId_fkey";

-- DropForeignKey
ALTER TABLE "TestResult" DROP CONSTRAINT "TestResult_studentId_fkey";

-- DropForeignKey
ALTER TABLE "TestResult" DROP CONSTRAINT "TestResult_testId_fkey";

-- DropTable
DROP TABLE "Course";

-- DropTable
DROP TABLE "CourseEnrollment";

-- DropTable
DROP TABLE "Test";

-- DropTable
DROP TABLE "TestResult";

-- DropTable
DROP TABLE "User";

-- DropEnum
DROP TYPE "UserRole";

-- CreateTable
CREATE TABLE "Export" (
    "id" TEXT NOT NULL,
    "consecutivo" TEXT NOT NULL,
    "customerId" INTEGER NOT NULL,
    "destinationCountry" TEXT NOT NULL,
    "destinationCity" TEXT NOT NULL,
    "transportMode" TEXT NOT NULL,
    "selectedShipping" TEXT,
    "status" TEXT NOT NULL,
    "globalProgress" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ShippingInstruction" (
    "id" TEXT NOT NULL,
    "bookingId" TEXT,
    "consigneeName" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "consigneePhone" TEXT NOT NULL,
    "consigneeEmail" TEXT NOT NULL,
    "deliveryAddress" TEXT NOT NULL,
    "notifyName" TEXT NOT NULL,
    "notifyPhone" TEXT NOT NULL,
    "instructions" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Booking" (
    "id" TEXT NOT NULL,
    "bookingNumber" TEXT NOT NULL,
    "shippingId" TEXT,
    "transportDocumentId" TEXT NOT NULL,
    "eta" TIMESTAMP(3) NOT NULL,
    "etd" TIMESTAMP(3) NOT NULL,
    "etaDestination" TIMESTAMP(3) NOT NULL,
    "documentsDeadline" TIMESTAMP(3) NOT NULL,
    "physicalLeadtime" TIMESTAMP(3) NOT NULL,
    "exportsId" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Supplier" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "role" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SupplierService" (
    "role" TEXT NOT NULL,
    "expoId" TEXT NOT NULL,
    "supplierId" TEXT NOT NULL,

    PRIMARY KEY ("expoId","supplierId")
);

-- CreateTable
CREATE TABLE "Contact" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "supplierId" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TransportService" (
    "containerId" TEXT NOT NULL,
    "supplierId" TEXT NOT NULL,

    PRIMARY KEY ("containerId","supplierId")
);

-- CreateTable
CREATE TABLE "Container" (
    "id" TEXT NOT NULL,
    "containerNumber" TEXT NOT NULL,
    "vehiculoId" TEXT NOT NULL,
    "transportId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "dateYardWithdraw" TIMESTAMP(3) NOT NULL,
    "dateLoad" TIMESTAMP(3) NOT NULL,
    "dateEnterPort" TIMESTAMP(3) NOT NULL,
    "dateDeparture" TIMESTAMP(3) NOT NULL,
    "netWeight" DOUBLE PRECISION NOT NULL,
    "grossWeight" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "bookingId" TEXT,

    PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Export.consecutivo_unique" ON "Export"("consecutivo");

-- CreateIndex
CREATE UNIQUE INDEX "Contact.email_unique" ON "Contact"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Container.containerNumber_unique" ON "Container"("containerNumber");

-- AddForeignKey
ALTER TABLE "ShippingInstruction" ADD FOREIGN KEY ("bookingId") REFERENCES "Booking"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Booking" ADD FOREIGN KEY ("exportsId") REFERENCES "Export"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SupplierService" ADD FOREIGN KEY ("expoId") REFERENCES "Export"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SupplierService" ADD FOREIGN KEY ("supplierId") REFERENCES "Supplier"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Contact" ADD FOREIGN KEY ("supplierId") REFERENCES "Supplier"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TransportService" ADD FOREIGN KEY ("containerId") REFERENCES "Container"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TransportService" ADD FOREIGN KEY ("supplierId") REFERENCES "Supplier"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Container" ADD FOREIGN KEY ("bookingId") REFERENCES "Booking"("id") ON DELETE SET NULL ON UPDATE CASCADE;
