today = Date.current

pine = Camp.create!(name: "Pine Ridge", capacity: 10)
lake = Camp.create!(name: "Lakeside", capacity: 4)
Camp.create!(name: "Meadow", capacity: 6)

# Peak occupancy at Pine Ridge is 9/10 on today+2 and today+3.
# Try booking 2 more people over those nights — it should be rejected.
pine.reservations.create!(name: "Novak family", amount: 4, start_date: today, end_date: today + 5)
pine.reservations.create!(name: "Svoboda family", amount: 3, start_date: today + 2, end_date: today + 8)
pine.reservations.create!(name: "Dvorak family", amount: 2, start_date: today, end_date: today + 3)

# Adjacent stays: checkout day is free, so both can use the full capacity of 4.
lake.reservations.create!(name: "Kovac", amount: 4, start_date: today, end_date: today + 3)
lake.reservations.create!(name: "Horak", amount: 4, start_date: today + 3, end_date: today + 6)
