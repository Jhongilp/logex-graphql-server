/*
  Warnings:

  - You are about to drop the column `exportsId` on the `Booking` table. All the data in the column will be lost.
  - You are about to drop the column `destinationCity` on the `Export` table. All the data in the column will be lost.
  - You are about to drop the column `destinationCountry` on the `Export` table. All the data in the column will be lost.
  - You are about to drop the column `selectedShipping` on the `Export` table. All the data in the column will be lost.
  - You are about to drop the column `bookingId` on the `ShippingInstruction` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Booking" DROP CONSTRAINT "Booking_exportsId_fkey";

-- DropForeignKey
ALTER TABLE "ShippingInstruction" DROP CONSTRAINT "ShippingInstruction_bookingId_fkey";

-- AlterTable
ALTER TABLE "Booking" DROP COLUMN "exportsId",
ADD COLUMN     "exportId" TEXT,
ADD COLUMN     "shippingInstructionId" TEXT;

-- AlterTable
ALTER TABLE "Export" DROP COLUMN "destinationCity",
DROP COLUMN "destinationCountry",
DROP COLUMN "selectedShipping",
ALTER COLUMN "transportMode" DROP NOT NULL;

-- AlterTable
ALTER TABLE "ShippingInstruction" DROP COLUMN "bookingId";

-- CreateTable
CREATE TABLE "Customer" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "address" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Export" ADD FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Booking" ADD FOREIGN KEY ("exportId") REFERENCES "Export"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Booking" ADD FOREIGN KEY ("shippingInstructionId") REFERENCES "ShippingInstruction"("id") ON DELETE SET NULL ON UPDATE CASCADE;
