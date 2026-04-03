export const mockAstrologers = [
  { id: "1", name: "Pandit Rajesh Sharma", speciality: "Vedic Astrology", experience: 15, rating: 4.8, pricePerMin: 20, avatar: "🧘", status: "online" as const, languages: ["Hindi", "English"], totalConsultations: 3500 },
  { id: "2", name: "Acharya Deepak Joshi", speciality: "Numerology", experience: 10, rating: 4.6, pricePerMin: 15, avatar: "🔮", status: "online" as const, languages: ["Hindi", "Sanskrit"], totalConsultations: 2100 },
  { id: "3", name: "Dr. Meena Gupta", speciality: "Tarot Reading", experience: 8, rating: 4.9, pricePerMin: 25, avatar: "🌙", status: "busy" as const, languages: ["Hindi", "English", "Gujarati"], totalConsultations: 1800 },
  { id: "4", name: "Guru Anand Mishra", speciality: "Palmistry", experience: 20, rating: 4.7, pricePerMin: 30, avatar: "✋", status: "offline" as const, languages: ["Hindi"], totalConsultations: 5200 },
  { id: "5", name: "Jyotishi Kavita Devi", speciality: "Kundli Matching", experience: 12, rating: 4.5, pricePerMin: 18, avatar: "⭐", status: "online" as const, languages: ["Hindi", "English"], totalConsultations: 2800 },
  { id: "6", name: "Pandit Suresh Tiwari", speciality: "Vastu Shastra", experience: 18, rating: 4.8, pricePerMin: 22, avatar: "🏠", status: "online" as const, languages: ["Hindi", "Marathi"], totalConsultations: 4100 },
];

export const kundliServices = [
  { id: "1", name: "Birth Chart (Janam Kundli)", icon: "📜", description: "Complete birth chart analysis with planetary positions", price: 299 },
  { id: "2", name: "Kundli Matching", icon: "💑", description: "Gun Milan for marriage compatibility", price: 499 },
  { id: "3", name: "Daily Horoscope", icon: "🌅", description: "Personalized daily predictions based on your chart", price: 0 },
  { id: "4", name: "Career Report", icon: "💼", description: "Detailed career and financial predictions", price: 599 },
  { id: "5", name: "Love & Relationship", icon: "❤️", description: "Insights into your love life and relationships", price: 399 },
  { id: "6", name: "Health Report", icon: "🏥", description: "Health predictions based on planetary positions", price: 349 },
  { id: "7", name: "Manglik Dosha", icon: "🔴", description: "Check Manglik Dosha in your kundli", price: 199 },
  { id: "8", name: "Sade Sati Report", icon: "🪐", description: "Saturn transit impact analysis", price: 249 },
];

export const zodiacSigns = [
  { name: "Aries", symbol: "♈", element: "Fire", date: "Mar 21 - Apr 19" },
  { name: "Taurus", symbol: "♉", element: "Earth", date: "Apr 20 - May 20" },
  { name: "Gemini", symbol: "♊", element: "Air", date: "May 21 - Jun 20" },
  { name: "Cancer", symbol: "♋", element: "Water", date: "Jun 21 - Jul 22" },
  { name: "Leo", symbol: "♌", element: "Fire", date: "Jul 23 - Aug 22" },
  { name: "Virgo", symbol: "♍", element: "Earth", date: "Aug 23 - Sep 22" },
  { name: "Libra", symbol: "♎", element: "Air", date: "Sep 23 - Oct 22" },
  { name: "Scorpio", symbol: "♏", element: "Water", date: "Oct 23 - Nov 21" },
  { name: "Sagittarius", symbol: "♐", element: "Fire", date: "Nov 22 - Dec 21" },
  { name: "Capricorn", symbol: "♑", element: "Earth", date: "Dec 22 - Jan 19" },
  { name: "Aquarius", symbol: "♒", element: "Air", date: "Jan 20 - Feb 18" },
  { name: "Pisces", symbol: "♓", element: "Water", date: "Feb 19 - Mar 20" },
];

export const mockUsers = [
  { id: "u1", name: "Rahul Kumar", email: "rahul@example.com", phone: "+91 98765 43210", walletBalance: 500, totalSpent: 2500, status: "active" as const, joinedAt: "2024-01-15" },
  { id: "u2", name: "Priya Singh", email: "priya@example.com", phone: "+91 87654 32109", walletBalance: 1200, totalSpent: 4800, status: "active" as const, joinedAt: "2024-02-20" },
  { id: "u3", name: "Amit Patel", email: "amit@example.com", phone: "+91 76543 21098", walletBalance: 0, totalSpent: 800, status: "blocked" as const, joinedAt: "2024-03-10" },
  { id: "u4", name: "Neha Sharma", email: "neha@example.com", phone: "+91 65432 10987", walletBalance: 350, totalSpent: 1500, status: "active" as const, joinedAt: "2024-04-05" },
];

export const mockWalletTransactions = [
  { id: "t1", userId: "u1", type: "credit" as const, amount: 500, description: "Wallet recharge", date: "2024-03-25" },
  { id: "t2", userId: "u1", type: "debit" as const, amount: 100, description: "Chat with Pandit Rajesh - 5 min", date: "2024-03-26" },
  { id: "t3", userId: "u2", type: "credit" as const, amount: 1000, description: "Wallet recharge", date: "2024-03-24" },
  { id: "t4", userId: "u2", type: "debit" as const, amount: 250, description: "Video call with Dr. Meena - 10 min", date: "2024-03-27" },
  { id: "t5", userId: "u1", type: "debit" as const, amount: 299, description: "Birth Chart (Janam Kundli)", date: "2024-03-28" },
];

export const chatEmojis = ["😊", "🙏", "🌟", "✨", "🔮", "🪐", "⭐", "🌙", "☀️", "🕉️", "📿", "🧘", "💫", "🌌", "♈", "♉", "♊", "♋", "♌", "♍", "♎", "♏", "♐", "♑", "♒", "♓", "👍", "❤️", "🙌", "💰", "📜", "🎯", "💎", "🌸", "🪷"];
