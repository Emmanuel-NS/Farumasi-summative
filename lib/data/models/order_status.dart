enum OrderStatus {
  pendingReview,     // 1. Pharmacist reviews prescription
  findingPharmacy,   // 2. Sent to pharmacy, waiting for acceptance/price
  pharmacyAccepted,  // 3. Pharmacy accepted, price received
  paymentPending,    // 4. Sent to patient with final price (drug + delivery)
  readyForPickup,    // 5. Patient paid, assigning driver
  driverAssigned,    // 6. Driver on the way to pharmacy
  outForDelivery,    // 7. Picked up, going to patient
  delivered,         // 8. Completed
  cancelled
}
