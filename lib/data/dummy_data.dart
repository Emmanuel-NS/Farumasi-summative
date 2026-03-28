import 'package:farumasi_patient_app/data/models/models.dart';

final List<HealthArticle> dummyHealthArticles = [
  HealthArticle(
    id: 'a1',
    title: "The Science of Hydration",
    subtitle: "More than just drinking water.",
    summary:
        "Why water is the most critical nutrient for your body's daily functions and how it affects your brain.",
    category: "General Health",
    readTimeMin: 4,
    imageUrl:
        "https://images.unsplash.com/photo-1548839140-29a749e1cf4d?auto=format&fit=crop&q=80&w=800",
    source: "Journal of Biological Chemistry",
    type: HealthArticleType.tip,
    fullContent: """
Water is essential for life, making up about 60% of the adult human body. Every cell, tissue, and organ in your body needs water to work properly.

**1. Regulates Body Temperature**
Water that is stored in middle layers of the skin comes to the skin's surface as sweat when the body heats up. As it evaporates, it cools the body. In sport.

**2. Lubricates Joints**
Cartilage, found in joints and the disks of the spine, contains around 80 percent water. Long-term dehydration can reduce the joints’ shock-absorbing ability, leading to joint pain.

**3. Boosts Performance**
A study published in 'Sports Medicine' found that dehydration reduces performance in activities lasting longer than 30 minutes. If you don’t stay hydrated, your physical performance can suffer.

**4. Prevents Headaches**
Dehydration can trigger headaches and migraine in some individuals. Research has shown that water can relieve headaches in those who are dehydrated.
    """,
  ),
  HealthArticle(
    id: 'a2',
    title: "Mastering Sleep Hygiene",
    subtitle: "The secret to 8 hours of deep rest.",
    summary:
        "Optimizing your environment and habits for restorative deep sleep.",
    category: "Wellness",
    readTimeMin: 6,
    imageUrl:
        "https://images.unsplash.com/photo-1541781777631-fa95375ed299?auto=format&fit=crop&q=80&w=800", // Bedroom/Sleep environment
    source: "National Sleep Foundation",
    type: HealthArticleType.tip,
    fullContent: """
Sleep serves to restore the body and mind. The National Sleep Foundation recommends 7-9 hours for adults.

**The Circadian Rhythm**
Your body has a natural time-keeping clock known as your circadian rhythm. It affects your brain, body, and hormones, helping you stay awake and telling your body when it's time to sleep.

**Blue Light Exposure**
Exposure to light during the day is beneficial, but nighttime light exposure has the opposite effect. This is due to its effect on your circadian rhythm, tricking your brain into thinking it is still daytime. Blue light—which electronic devices like smartphones and computers emit in large amounts—is the worst in this regard.

**Caffeine Cuts**
Caffeine has numerous benefits and is consumed by 90% of the US population. However, when consumed late in the day, caffeine stimulates your nervous system and may stop your body from naturally relaxing at night.
    """,
  ),
  HealthArticle(
    id: 'r1',
    title: "Flu & Cold Recovery",
    subtitle: "Virus Defense Protocol",
    summary: "Science-backed natural methods to shorten recovery time.",
    category: "Viral Infection",
    readTimeMin: 4,
    imageUrl:
        "https://images.unsplash.com/photo-1512568400610-62da28bc8a13?auto=format&fit=crop&q=80&w=800", // Tea/Hot drink
    source: "Mayo Clinic",
    type: HealthArticleType.remedy,
    fullContent: """
Influenza (Flu) is a viral infection that attacks your respiratory system. While rest is paramount, these natural methods can support recovery.

**1. Honey and Tea**
Honey is a natural cough suppressant. A study in 'Archives of Pediatrics & Adolescent Medicine' found that honey was more effective than common cough suppressants for treating nighttime coughs.
*Usage*: Mix 2 teaspoons of honey with herbal tea or warm water and lemon.

**2. Steam Inhalation**
Inhaling steam helps thin mucus and drain the sinuses.
*Usage*: Pour hot water into a bowl, drape a towel over your head, and breathe deeply for 5-10 minutes.

**3. Zinc Supplementation**
Research suggests that zinc lozenges may shorten the length of a cold if taken within 24 hours of symptoms appearing.
    """,
  ),
  HealthArticle(
    id: 'r2',
    title: "Natural Diabetes Management",
    subtitle: "Lifestyle Control",
    summary: "How diet and stress management significantly impact blood sugar.",
    category: "Chronic Care",
    readTimeMin: 7,
    imageUrl:
        "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=800", // Healthy Salad
    source: "American Diabetes Association",
    type: HealthArticleType.remedy,
    fullContent: """
Type 2 diabetes management relies heavily on lifestyle.

**1. Fiber-Rich Diet**
Fiber slows carb digestion and sugar absorption. For these reasons, it promotes a more gradual rise in blood sugar levels. 
*Action*: Focus on non-starchy vegetables, legumes, and whole grains.

**2. Apple Cider Vinegar**
Apple cider vinegar has many health benefits. Although it is made from apples, the fruit's sugar is fermented into acetic acid. Research shows it promotes lower fasting blood sugar levels.
*Usage*: Mix 1 tsp in a glass of water before a meal.
    """,
  ),
  HealthArticle(
    id: 'dk1',
    title: "Did You Know?",
    subtitle: "Fun Fact #1",
    summary: "Bananas are berries, but strawberries aren't!",
    category: "Trivia",
    readTimeMin: 1,
    imageUrl: "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e",
    source: "Botanical Definitions",
    type: HealthArticleType.didYouKnow,
    fullContent:
        "In botanical terms, a berry is a fruit produced from the ovary of a single flower with seeds embedded in the flesh. By this definition, bananas meet the criteria, while strawberries do not because their seeds are on the outside.",
  ),
];

final List<Medicine> dummyMedicines = [
  Medicine(
    id: 'm1',
    name: 'Paracetamol 500mg',
    description:
        'Effective pain reliever and fever reducer. Suitable for headaches, muscle aches, and colds.',
    price: 500,
    maxPrice: 800, // Price range: 500 - 800
    expiryDate: '12/2026',
    imageUrl:
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80',
    category: 'Pain Relief',
    subCategory: 'Headache & Fever',
    rating: 4.8,
    isPopular: true,
    dosage:
        'Adults: 1-2 tablets every 4-6 hours. Do not exceed 8 tablets in 24 hours.',
    sideEffects:
        'Rare: Allergic reactions, skin rash. High doses may cause liver damage.',
    manufacturer: 'HealthLive Pharma',
    keywords: [
      'headache',
      'fever',
      'flu',
      'pain',
      'body ache',
      'temperature',
      'cold',
    ],
    doseMorning: '1 Tablet',
    doseAfternoon: '1 Tablet',
    doseEvening: '1 Tablet',
    doseTimeInterval: 'Every 8 hours',
  ),
  Medicine(
    id: 'm2',
    name: 'Amoxicillin 250mg',
    description:
        'Antibiotic used to treat bacterial infections. Requires a valid doctor\'s prescription.',
    price: 2500,
    maxPrice: 3200,
    expiryDate: '06/2025',
    imageUrl:
        'https://images.unsplash.com/photo-1585435557343-3b092031a831?w=600&q=80',
    category: 'Antibiotics',
    subCategory: 'Bacterial Infections',
    requiresPrescription: true,
    rating: 4.5,
    dosage:
        'Take 1 capsule every 8 hours for 7 days. Complete the full course.',
    sideEffects: 'Nausea, diarrhea, stomach pain. Stop if rash appears.',
    manufacturer: 'Global Antibiotics Ltd.',
    keywords: ['infection', 'bacteria', 'throat', 'chest', 'pneumonia'],
    doseMorning: '1-2 Tablets',
    doseEvening: '1-2 Tablets',
    doseTimeInterval: '12 Hours',
  ),
  Medicine(
    id: 'm3',
    name: 'Vitamin C 1000mg',
    description:
        'High-potency immune system booster to keep you healthy and energized.',
    price: 8000,
    maxPrice: 9500,
    expiryDate: '11/2026',
    imageUrl:
        'https://images.unsplash.com/photo-1616671276445-169d9e3b2e36?w=600&q=80',
    category: 'Vitamins',
    subCategory: 'Immunity',
    isPopular: true,
    rating: 4.9,
    dosage: 'Dissolve one tablet in a glass of water daily.',
    sideEffects: 'High doses may cause stomach upset or kidney stones.',
    manufacturer: 'VitaBoost Inc.',
    keywords: ['immune', 'flu', 'cold', 'supplement', 'energy', 'vitality'],
  ),
  Medicine(
    id: 'm4',
    name: 'Cough Syrup',
    description:
        'Fast-acting relief from dry and chesty coughs. Cherry flavor.',
    price: 3500,
    // No maxPrice -> Fixed Price
    expiryDate: '01/2027',
    imageUrl:
        'https://images.unsplash.com/photo-1598454519524-8f0a1c87607a?w=600&q=80',
    category: 'Cold & Flu',
    subCategory: 'Cough Syrups',
    rating: 4.2,
    dosage: '10ml every 6 hours. Not for children under 6 years.',
    sideEffects: 'May cause drowsiness or dizziness.',
    manufacturer: 'CureWell Labs',
    keywords: ['cough', 'throat', 'chest', 'congestion', 'mucus', 'cold'],
  ),
  Medicine(
    id: 'm5',
    name: 'Ibuprofen 400mg',
    description:
        'Non-steroidal anti-inflammatory drug (NSAID) for pain relief and inflammation.',
    price: 1500,
    maxPrice: 2000,
    expiryDate: '08/2026',
    imageUrl:
        'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80',
    category: 'Pain Relief',
    subCategory: 'Muscle Pain',
    isPopular: true,
    rating: 4.7,
    dosage: 'Take with food. 1 tablet every 6-8 hours as needed.',
    sideEffects: 'Stomach pain, heartburn. Prolonged use risks stomach ulcers.',
    manufacturer: 'Relief Meds',
    keywords: [
      'inflammation',
      'swelling',
      'back pain',
      'period pain',
      'headache',
      'pain',
    ],
  ),
  Medicine(
    id: 'm6',
    name: 'Aloe Vera Gel',
    description:
        'Pure soothing gel for sunburns, skin irritations, and daily moisturizing.',
    price: 6000,
    maxPrice: 7500,
    expiryDate: '12/2025',
    imageUrl:
        'https://images.unsplash.com/photo-1620916773340-753bc9f77651?w=600&q=80',
    category: 'Skincare',
    subCategory: 'Moisturizers',
    rating: 4.6,
    dosage: 'Apply liberally to affected area as often as needed.',
    sideEffects: 'Rarely causes allergic dermatitis in sensitive individuals.',
    manufacturer: 'Nature\'s Touch',
    keywords: ['skin', 'sunburn', 'moisturizer', 'burn', 'rash', 'soothing'],
  ),
  Medicine(
    id: 'm7',
    name: 'Multivitamin Complex',
    description:
        'Complete daily nutritional support with essential vitamins and minerals.',
    price: 12000,
    maxPrice: 15000,
    expiryDate: '05/2027',
    imageUrl:
        'https://images.unsplash.com/photo-1576073719676-aa95576db207?w=600&q=80',
    category: 'Vitamins',
    subCategory: 'Supplements',
    isPopular: true,
    rating: 4.9,
    dosage: 'One tablet daily with a main meal.',
    sideEffects: 'Generally well tolerated. Check ingredients for allergens.',
    manufacturer: 'DailyVits',
    keywords: ['energy', 'health', 'daily', 'supplement', 'minerals'],
  ),
  Medicine(
    id: 'm8',
    name: 'Hand Sanitizer',
    description:
        'Alcohol-based hand sanitizer that kills 99.9% of germs instantly.',
    price: 2000,
    maxPrice: 3000,
    expiryDate: '10/2025',
    imageUrl:
        'https://images.unsplash.com/photo-1584744982491-6652d3d3a778?w=600&q=80',
    category: 'Hygiene',
    subCategory: 'Hand Hygiene',
    rating: 4.5,
    dosage: 'Apply palmful to hands and rub until dry.',
    sideEffects: 'May cause skin dryness with frequent use.',
    manufacturer: 'CleanHands Co.',
    keywords: ['germs', 'bacteria', 'clean', 'virus', 'alcohol', 'hands'],
  ),
  Medicine(
    id: 'm9',
    name: 'Face Mask (N95)',
    description:
        'High filtration respiratory protection. Comfortable fit for daily use.',
    price: 1000,
    maxPrice: 1500,
    expiryDate: 'N/A', // Consumable
    imageUrl:
        'https://images.unsplash.com/photo-1585776245991-cf79dd4e5e40?w=600&q=80',
    category: 'Hygiene',
    subCategory: 'Protective Gear',
    isPopular: true,
    rating: 4.8,
    dosage: 'Wear covering nose and mouth. Dispose after use.',
    sideEffects: 'None known.',
    manufacturer: 'SafeBreath',
    keywords: ['mask', 'protection', 'virus', 'dust', 'pollution'],
  ),
  Medicine(
    id: 'm10',
    name: 'Sunscreen SPF 50',
    description:
        'Broad-spectrum protection against UVA and UVB rays. Water-resistant.',
    price: 8500,
    maxPrice: 10000,
    expiryDate: '03/2026',
    imageUrl:
        'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=600&q=80',
    category: 'Skincare',
    subCategory: 'Sun Protection',
    rating: 4.7,
    dosage: 'Apply 15 minutes before sun exposure. Reapply every 2 hours.',
    sideEffects: 'Avoid contact with eyes.',
    manufacturer: 'SunGuard',
    keywords: ['sun', 'protection', 'burn', 'spf', 'uv', 'skin'],
  ),
  // New Categories
  Medicine(
    id: 'm19',
    name: 'Protein Powder (Whey)',
    description: 'Premium whey protein for muscle recovery and growth.',
    price: 45000,
    maxPrice: 60000,
    expiryDate: '09/2026',
    imageUrl:
        'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80',
    category: 'Nutrition',
    subCategory: 'Supplements',
    rating: 4.8,
    dosage: 'Mix one scoop with 250ml water or milk after workout.',
    sideEffects: 'May cause bloating in lactose intolerant individuals.',
    manufacturer: 'MuscleMax',
    keywords: ['gym', 'workout', 'muscle', 'protein', 'supplement'],
  ),
  Medicine(
    id: 'm20',
    name: 'Fish Oil Omega-3',
    description: 'Essential fatty acids for heart and brain health.',
    price: 15000,
    maxPrice: 18500,
    expiryDate: '04/2027',
    imageUrl:
        'https://images.unsplash.com/photo-1551601651-2a8555f1a136?w=600&q=80',
    category: 'Nutrition',
    subCategory: 'Supplements',
    rating: 4.7,
    isPopular: true,
    dosage: '1 capsule twice daily with meals.',
    sideEffects: 'Fishy aftertaste.',
    manufacturer: 'OceanPure',
    keywords: ['heart', 'brain', 'omega', 'fish', 'supplement'],
  ),
  Medicine(
    id: 'm21',
    name: 'Turmeric Curcumin',
    description: 'Natural herbal supplement for joint health and inflammation.',
    price: 12000,
    maxPrice: 14000,
    expiryDate: '12/2026',
    imageUrl:
        'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=600&q=80',
    category: 'Herbal Medicines',
    subCategory: 'Supplements',
    rating: 4.6,
    dosage: '1 capsule daily.',
    sideEffects: 'Generally safe. Consult doctor if pregnant.',
    manufacturer: 'HerbalLife',
    keywords: ['herb', 'joint', 'pain', 'natural', 'spice'],
  ),
  Medicine(
    id: 'm22',
    name: 'Ginseng Extract',
    description: 'Herbal energy booster and cognitive enhancer.',
    price: 18000,
    maxPrice: 22000,
    expiryDate: '11/2025',
    imageUrl:
        'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600&q=80',
    category: 'Herbal Medicines',
    subCategory: 'Supplements',
    rating: 4.5,
    dosage: 'Take one vial daily in the morning.',
    sideEffects: 'May cause insomnia if taken late.',
    manufacturer: 'RootsOrganic',
    keywords: ['energy', 'herb', 'focus', 'brain', 'stimulant'],
  ),
  Medicine(
    id: 'm11',
    name: 'Condoms (Pack of 3)',
    description: 'Latex condoms for protection and safe family planning.',
    price: 1500,
    maxPrice: 2000,
    expiryDate: '01/2028',
    imageUrl:
        'https://images.unsplash.com/photo-1629198728256-654bd7f8e329?w=600&q=80',
    category: 'Sexual Health',
    subCategory: 'Contraceptives',
    rating: 4.5,
    dosage: 'Use once during intercourse.',
    sideEffects: 'Latex allergy.',
    manufacturer: 'SafeLove',
    keywords: ['sex', 'protection', 'contraceptive', 'safe', 'latex'],
  ),
  Medicine(
    id: 'm12',
    name: 'Pregnancy Test Kit',
    description: 'Fast and accurate home pregnancy test.',
    price: 2500,
    maxPrice: 3500,
    expiryDate: '03/2026',
    imageUrl:
        'https://images.unsplash.com/photo-1629868744577-be804a621cda?w=600&q=80',
    category: 'Sexual Health',
    subCategory: 'Diagnostics',
    rating: 4.8,
    dosage: 'Follow instructions on pack.',
    sideEffects: 'None.',
    manufacturer: 'QuickCheck',
    keywords: ['test', 'pregnancy', 'baby', 'home test', 'check'],
  ),
  Medicine(
    id: 'm13',
    name: 'Wheelchair (Standard)',
    description:
        'Foldable standard wheelchair with comfortable seating. Durable frame.',
    price: 150000,
    maxPrice: 180000,
    expiryDate: 'N/A',
    imageUrl:
        'https://images.unsplash.com/photo-1582648792078-4384a22c1611?w=600&q=80',
    category: 'Mobility Aids',
    subCategory: 'Equipment',
    requiresPrescription: true,
    rating: 4.9,
    dosage: 'N/A',
    sideEffects: 'N/A',
    manufacturer: 'OrthoMove',
    keywords: ['mobility', 'chair', 'disabled', 'walking', 'aid'],
  ),
  Medicine(
    id: 'm14',
    name: 'Adjustable Walking Cane',
    description: 'Lightweight aluminum walking stick with non-slip tip.',
    price: 15000,
    maxPrice: 20000,
    expiryDate: 'N/A',
    imageUrl:
        'https://images.unsplash.com/photo-1533618467263-9a6d5ae5844c?w=600&q=80',
    category: 'Mobility Aids',
    subCategory: 'Walking Aids',
    rating: 4.6,
    dosage: 'Adjust height to hip level.',
    sideEffects: 'N/A',
    manufacturer: 'OrthoMove',
    keywords: ['walking', 'stick', 'cane', 'aid', 'mobility'],
  ),
  Medicine(
    id: 'm15',
    name: 'Baby Diapers (Pack of 50)',
    description: 'Soft and absorbent diapers for babies. Leak protection.',
    price: 18000,
    maxPrice: 21000,
    expiryDate: 'N/A',
    imageUrl:
        'https://images.unsplash.com/photo-1581093583449-ed25213bc51c?w=600&q=80',
    category: 'Mother & Baby',
    subCategory: 'Baby Care',
    isPopular: true,
    rating: 4.8,
    dosage: 'Change when wet.',
    sideEffects: 'Diaper rash if not changed frequently.',
    manufacturer: 'SoftBums',
    keywords: ['baby', 'diaper', 'nappy', 'infant', 'care'],
  ),
  Medicine(
    id: 'm16',
    name: 'Blood Pressure Monitor',
    description: 'Digital automatic upper arm blood pressure monitor.',
    price: 35000,
    maxPrice: 42000,
    expiryDate: 'N/A',
    imageUrl:
        'https://images.unsplash.com/photo-1628348068358-11d354eaaf6e?w=600&q=80',
    category: 'Devices',
    subCategory: 'Monitors',
    rating: 4.7,
    dosage: 'Use seated with arm at heart level.',
    sideEffects: 'N/A',
    manufacturer: 'MediTech',
    keywords: ['bp', 'blood', 'pressure', 'heart', 'monitor', 'test'],
  ),
  Medicine(
    id: 'm17',
    name: 'First Aid Kit',
    description: 'Comprehensive kit with bandages, antiseptic, and tools.',
    price: 22000,
    maxPrice: 28000,
    expiryDate: '01/2026',
    imageUrl:
        'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600&q=80',
    category: 'First Aid',
    subCategory: 'Kits',
    rating: 4.9,
    dosage: 'See individual items.',
    sideEffects: 'N/A',
    manufacturer: 'EmergencyReady',
    keywords: ['emergency', 'bandage', 'kit', 'aid', 'safety'],
  ),
  Medicine(
    id: 'm18',
    name: 'Insulin Syringes',
    description: 'Sterile syringes for insulin injection.',
    price: 5000,
    maxPrice: 6500,
    expiryDate: '06/2028',
    imageUrl:
        'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=600&q=80',
    category: 'Chronic Care',
    subCategory: 'Diabetes Care',
    requiresPrescription: true,
    rating: 4.6,
    dosage: 'Single use only.',
    sideEffects: 'N/A',
    manufacturer: 'DiabeticCare',
    keywords: ['diabetes', 'insulin', 'needle', 'syringe', 'injection'],
  ),
  Medicine(
    id: 'm23',
    name: 'Aspirin 81mg (Low Dose)',
    description:
        'Pain reliever and anti-inflammatory. Often used for heart health under medical advice.',
    price: 3000,
    maxPrice: 4000,
    expiryDate: '08/2027',
    imageUrl:
        'https://images.unsplash.com/photo-1626240228809-54157d079419?auto=format&fit=crop&q=80&w=600',
    category: 'Pain Relief',
    subCategory: 'Headache & Fever',
    rating: 4.7,
    dosage: 'Take with water. Consult doctor for daily regimen.',
    sideEffects: 'Stomach irritation. bleeding risk.',
    manufacturer: 'Bayer',
    keywords: ['pain', 'heart', 'headache', 'blood thinner'],
  ),
  Medicine(
    id: 'm24',
    name: 'Cetirizine 10mg',
    description:
        'Relief from allergy symptoms like sneezing, runny nose, and itchy eyes.',
    price: 2500,
    maxPrice: 3500,
    expiryDate: '05/2026',
    imageUrl:
        'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?auto=format&fit=crop&q=80&w=600',
    category: 'Cold & Flu',
    subCategory: 'Allergies',
    rating: 4.6,
    dosage: 'One tablet daily.',
    sideEffects: 'May cause drowsiness.',
    manufacturer: 'AllerEze',
    keywords: ['allergy', 'sneeze', 'itch', 'hay fever'],
  ),
  Medicine(
    id: 'm25',
    name: 'Hydrating Facial Cream',
    description: 'Deep hydration for dry and sensitive skin.',
    price: 12000,
    maxPrice: 16000,
    expiryDate: '11/2026',
    imageUrl:
        'https://images.unsplash.com/photo-1608248597279-f99d160bfbc8?auto=format&fit=crop&q=80&w=600',
    category: 'Skincare',
    subCategory: 'Moisturizers',
    rating: 4.8,
    dosage: 'Apply morning and night.',
    sideEffects: 'None known.',
    manufacturer: 'GlowSkin',
    keywords: ['face', 'cream', 'dry skin', 'sensitive'],
  ),
];

final List<HealthTip> dummyHealthTips = [
  HealthTip(
    id: 't1',
    title: 'Benefits of Ginger',
    content:
        'Ginger is great for digestion and reducing nausea. It also has anti-inflammatory properties that can help with muscle pain.',
    imageUrl:
        'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?auto=format&fit=crop&q=80&w=600',
  ),
  HealthTip(
    id: 't2',
    title: 'Stay Hydrated',
    content:
        'Drinking enough water is crucial for maintaining bodily functions, regulating temperature, and keeping your skin healthy.',
    imageUrl:
        'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?auto=format&fit=crop&q=80&w=600',
  ),
  HealthTip(
    id: 't3',
    title: 'Garlic for Immunity',
    content:
        'Garlic supplements are known to boost the function of the immune system and can prevent common colds.',
    imageUrl:
        'https://images.unsplash.com/photo-1615485925694-a0391632402a?auto=format&fit=crop&q=80&w=600',
  ),
];

final List<Pharmacy> dummyPharmacies = [
  Pharmacy(
    id: "ph1",
    name: "Farumasi Pharmacy",
    locationName: "Kigali Heights, KG 7 Ave",
    coordinates: [-1.9540, 30.0926],
    supportedInsurances: ["RSSB", "UAP", "MMI"],
    imageUrl:
        "https://images.unsplash.com/photo-1585435557343-3b092031a831?w=600&q=80",
    province: "Kigali City",
    district: "Gasabo",
    sector: "Kimihurura",
    cell: "Kimihurura",
  ),
  Pharmacy(
    id: "ph2",
    name: "City Chemist",
    locationName: "UTC Building, City Center",
    coordinates: [-1.9441, 30.0619],
    supportedInsurances: ["RSSB", "RADIANT"],
    imageUrl:
        "https://images.unsplash.com/photo-1631549916768-4119b2e5f926?w=600&q=80",
    province: "Kigali City",
    district: "Nyarugenge",
    sector: "Nyarugenge",
    cell: "Kiyovu",
  ),
  Pharmacy(
    id: "ph3",
    name: "HealthPlus Nyamirambo",
    locationName: "Nyamirambo Market",
    coordinates: [-1.9804, 30.0416],
    supportedInsurances: ["RSSB", "UAP"],
    imageUrl:
        "https://images.unsplash.com/photo-1576602976047-174e57a47881?w=600&q=80",
    province: "Kigali City",
    district: "Nyarugenge",
    sector: "Nyamirambo",
    cell: "Mumena",
  ),
  Pharmacy(
    id: "ph4",
    name: "Remera Modern Pharmacy",
    locationName: "Giporoso, Remera",
    coordinates: [-1.9610, 30.1118],
    supportedInsurances: ["RSSB", "MMI"],
    imageUrl:
        "https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=600&q=80",
    province: "Kigali City",
    district: "Gasabo",
    sector: "Remera",
    cell: "Rukiri I",
  ),
  Pharmacy(
    id: "ph5",
    name: "Kicukiro Central Pharmacy",
    locationName: "Kicukiro Centre, Sonatubes",
    coordinates: [-1.9704, 30.1009],
    supportedInsurances: ["RSSB", "RADIANT", "BK"],
    imageUrl:
        "https://images.unsplash.com/photo-1542736667-069246bda5d4?w=600&q=80",
    province: "Kigali City",
    district: "Kicukiro",
    sector: "Kicukiro",
    cell: "Ngoma",
  ),
  Pharmacy(
    id: "ph6",
    name: "Nyarutarama Care Pharmacy",
    locationName: "MTN Centre, Nyarutarama",
    coordinates: [-1.9427, 30.1017],
    supportedInsurances: ["RSSB", "UAP", "Sanlam"],
    imageUrl:
        "https://images.unsplash.com/photo-1631553556445-568eb2a1d2e5?w=600&q=80",
    province: "Kigali City",
    district: "Gasabo",
    sector: "Remera",
    cell: "Nyarutarama",
  ),
  Pharmacy(
    id: "ph7",
    name: "Kimironko Life Pharmacy",
    locationName: "Kimironko Market Area",
    coordinates: [-1.9443, 30.1256],
    supportedInsurances: ["RSSB", "MMI"],
    imageUrl:
        "https://images.unsplash.com/photo-1576602976214-722de1cb1f39?w=600&q=80",
    province: "Kigali City",
    district: "Gasabo",
    sector: "Kimironko",
    cell: "Nyagatovu",
  ),
  Pharmacy(
    id: "ph8",
    name: "Gisozi Wellness Pharmacy",
    locationName: "Gisozi Sector Office",
    coordinates: [-1.9288, 30.0711],
    supportedInsurances: ["RSSB", "RADIANT"],
    imageUrl:
        "https://images.unsplash.com/photo-1631549916768-4119b2e5f926?w=600&q=80",
    province: "Kigali City",
    district: "Gasabo",
    sector: "Gisozi",
    cell: "Musezero",
  ),
  Pharmacy(
    id: "ph9",
    name: "Kanombe Community Pharmacy",
    locationName: "Near Kanombe Military Hospital",
    coordinates: [-1.9680, 30.1458],
    supportedInsurances: ["RSSB", "MMI", "UAP", "BK"],
    imageUrl:
        "https://images.unsplash.com/photo-1542736705-53f0131d1e98?w=600&q=80",
    province: "Kigali City",
    district: "Kicukiro",
    sector: "Kanombe",
    cell: "Rubirizi",
  ),
];

final dummyPharmacists = [
  Pharmacist(
    id: '1',
    name: 'Dr. John Doe',
    specialty: 'Clinical Pharmacist',
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/387/387561.png',
    organization: 'Kigali City Pharmacy',
    status: PharmacistStatus.available,
    yearsExperience: 8,
  ),
  Pharmacist(
    id: '2',
    name: 'Dr. Sarah Smith',
    specialty: 'Pediatric Specialist',
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/387/387569.png',
    organization: 'Rwanda Children\'s Hospital',
    status: PharmacistStatus.busy,
    yearsExperience: 12,
  ),
  Pharmacist(
    id: '3',
    name: 'Dr. Michael Chen',
    specialty: 'Geriatric Care',
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/387/387561.png',
    organization: 'Remera Pharmacy',
    status: PharmacistStatus.offline,
    yearsExperience: 6,
  ),
];
