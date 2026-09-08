# 🎰 Casino Game iOS App

A comprehensive, feature-rich iOS casino game application built with **Swift** and **SwiftUI**. Play multiple casino games, manage your wallet, track statistics, and climb the levels!

## ✨ Features

### 🎮 Games
- **Slots** - Classic slot machine game with multiple symbols and multipliers
- **Blackjack** - Beat the dealer with strategic gameplay
- **Roulette** - Pick your number and spin the wheel
- **Poker** - Test your hand strength against the dealer
- **Dice** - Roll the dice and predict the outcome

### 💰 Wallet System
- Deposit and withdraw funds
- Real-time balance tracking
- Transaction history
- Betting limits (daily, weekly, monthly)

### 📊 Statistics & Analytics
- Game history tracking
- Win/loss statistics
- Level progression system
- Achievements system
- Win streaks and performance metrics

### 🔐 User Management
- Secure login/signup
- User profiles
- Authentication
- Session management

### 🎵 Audio & Haptics
- Sound effects for wins/losses
- Background music
- Haptic feedback
- Immersive gaming experience

## 🛠️ Technology Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM with ObservableObject
- **Data Persistence**: UserDefaults, Core Data ready
- **iOS Minimum**: iOS 15.0
- **Platforms**: iPhone, iPad (Universal)

## 📁 Project Structure

```
CasinoGame/
├── Models/
│   ├── Player.swift          # User model
│   ├── Game.swift            # Game types and results
│   └── Wallet.swift          # Wallet and transaction models
├── Views/
│   ├── ContentView.swift     # Main app entry
│   ├── LoginView.swift       # Authentication UI
│   ├── GameSelectionView.swift
│   ├── Games/
│   │   ├── SlotsGameView.swift
│   │   ├── BlackjackGameView.swift
│   │   ├── RouletteGameView.swift
│   │   ├── DiceGameView.swift
│   │   └── PokerGameView.swift
│   ├── WalletView.swift      # Wallet management
│   ├── ProfileView.swift     # User profile
│   ├── StatsView.swift       # Statistics
│   └── GameResultView.swift  # Result display
├── Services/
│   ├── AuthService.swift     # Authentication logic
│   ├── PlayerService.swift   # Player data management
│   ├── GameService.swift     # Game logic
│   ├── AnalyticsService.swift # Tracking and analytics
│   └── SoundService.swift    # Audio management
└── README.md
```

## 🚀 Quick Start

### Requirements
- Xcode 14.0+
- Swift 5.9+
- iOS 15.0+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/marcossabate-oss/casino-game-ios.git
   cd casino-game-ios
   ```

2. **Open in Xcode**
   ```bash
   open CasinoGame.xcodeproj
   ```

3. **Select your target device/simulator**
   - iPhone 14 Pro or later recommended
   - iPad supported

4. **Build and Run**
   - Press `Cmd + R` or click the Run button

## 🎮 How to Play

### Getting Started
1. **Create an Account** - Sign up with username and password
2. **Get Welcome Bonus** - Receive $1000 starting balance
3. **Choose a Game** - Select from 5 different games
4. **Place Your Bet** - Adjust bet amount using the slider
5. **Play and Win** - Follow game-specific rules
6. **Track Progress** - Check your stats and achievements

### Game Rules

#### Slots (2:1 to 20:1 multiplier)
- Match all three symbols to win
- Different symbols have different payouts
- 🍎 = 5x, 🍊 = 7x, 🍋 = 10x, 🍌 = 15x, 🍉 = 20x

#### Blackjack
- Get 21 or beat the dealer
- Hit or Stand
- Bust = lose bet
- 21 = 2x payout

#### Roulette
- Pick a number (0-36)
- Spin the wheel
- Match = 36x payout

#### Dice
- Predict the sum (2-12)
- Roll two dice
- Match = 5x payout

#### Poker
- Select your hand strength
- Dealer deals
- Higher hand wins
- 2x payout on win

## 🎯 Game Features

### Levels & Progression
- Start at Level 1
- Earn $1000 per level
- Unlock achievements
- Higher levels, higher prestige

### Achievements
- 🏆 **First 10 Games** - Play 10 games
- 🔥 **Hot Streak** - Win 5 games in a row
- 💰 **Big Winner** - Win $5000 total
- 🎯 **Jackpot Hit** - Win $1000 in single game

### Statistics Tracked
- Total games played
- Total winnings/losses
- Win/loss ratio
- Favorite game
- Longest win streak
- Current win streak
- Average bet size
- Largest win
- Largest loss

## 💻 Development

### Architecture Pattern
- **MVVM** - Clean separation of concerns
- **ObservableObject** - Reactive state management
- **Services** - Singleton pattern for shared services
- **SwiftUI** - Declarative UI

### Adding New Games

1. **Add Game Type** to `Game.swift`:
   ```swift
   case newGame = "New Game"
   ```

2. **Create Game Logic** in `GameService.swift`:
   ```swift
   func playNewGame(bet: Double) -> GameResult {
       // Implement game logic
       return GameResult(...)
   }
   ```

3. **Create Game View**:
   ```swift
   struct NewGameView: View {
       // Implement UI
   }
   ```

4. **Add to GameSelectionView**:
   ```swift
   NavigationLink(destination: NewGameView()) {
       GameCard(game: .newGame)
   }
   ```

## 🔧 Customization

### Change Starting Balance
In `AuthService.swift`:
```swift
let user = Player(
    username: username,
    email: email,
    balance: 5000.0,  // Change this value
    // ...
)
```

### Adjust Bet Limits
In game views:
```swift
Slider(value: $bet, in: 1...500, step: 1)  // Adjust range
```

### Customize House Edge
In `GameService.swift`:
```swift
func calculateHouseEdge(_ gameType: GameType) -> Double {
    switch gameType {
    case .slots:
        return 0.05  // 5% house edge
    // ...
    }
}
```

## 📱 Screenshots

### Login Screen
- Clean, modern authentication UI
- Support for signup and login
- Beautiful gradient backgrounds

### Game Selection
- Browse 5 different games
- Real-time balance display
- Game descriptions

### Gameplay
- Immersive game interfaces
- Intuitive controls
- Real-time feedback

### Wallet
- Deposit/Withdraw funds
- Quick amount buttons
- Transaction history

### Profile
- Player statistics
- Level progression
- Achievements
- Member info

## 🎵 Sound Effects

The app includes sounds for:
- Win/Loss notifications
- Spin/Roll actions
- Chip sounds
- Card dealing
- Bet placement
- Jackpot celebrations

*Note: Add audio files to Assets.xcassets*

## 🔐 Security Considerations

- Passwords are validated (min 6 characters)
- Email validation included
- Session management
- Two-factor authentication ready
- Secure data storage ready (Core Data)

## 🚀 Future Enhancements

- [ ] Backend integration with Firebase/Node.js
- [ ] Multiplayer features
- [ ] Real money transactions
- [ ] Social features (friends, leaderboards)
- [ ] More games (Keno, Bingo, etc.)
- [ ] VIP tiers and rewards
- [ ] Live dealer games
- [ ] Mobile app animations
- [ ] Dark/Light theme toggle
- [ ] Multiple language support
- [ ] Push notifications
- [ ] Apple Pay integration

## 📊 Backend Setup (Optional)

For backend integration, consider:

### Firebase
```swift
import FirebaseAuth
import FirebaseDatabase
```

### Node.js + Express
```javascript
const express = require('express');
const app = express();
// API endpoints
```

### Database Schema
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255),
    balance DECIMAL(10,2),
    created_at TIMESTAMP
);

CREATE TABLE game_results (
    id UUID PRIMARY KEY,
    user_id UUID,
    game_type VARCHAR(50),
    bet_amount DECIMAL(10,2),
    win_amount DECIMAL(10,2),
    created_at TIMESTAMP
);
```

## 🐛 Debugging

### Enable Console Logging
```swift
import os.log
let logger = Logger(subsystem: "com.casino.game", category: "Debug")
logger.debug("Game result: \(result)")
```

### Xcode Debugging
- Set breakpoints with `Cmd + \`
- Use Debug View Hierarchy: `Cmd + Alt + Shift + H`
- Console: `Cmd + Shift + Y`

## 📝 Testing

### Unit Tests
```swift
import XCTest
@testable import CasinoGame

class GameServiceTests: XCTestCase {
    func testSlotsGameResult() {
        let gameService = GameService()
        let result = gameService.playSlots(bet: 10)
        XCTAssertEqual(result.betAmount, 10)
    }
}
```

### UI Tests
```swift
import XCTest

class CasinoGameUITests: XCTestCase {
    func testLoginFlow() {
        let app = XCUIApplication()
        app.launch()
        // UI test code
    }
}
```

## 📄 License

MIT License - See LICENSE file for details

## 👨‍💻 Author

**Marcos Sabate**
- GitHub: [@marcossabate-oss](https://github.com/marcossabate-oss)
- Portfolio: [Your Portfolio]

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 💬 Support

For issues and questions:
- Open an Issue on GitHub
- Check existing issues first
- Provide detailed description
- Include error messages/screenshots

## 📚 Resources

- [SwiftUI Documentation](https://developer.apple.com/xcode/swiftui/)
- [Swift Language Guide](https://docs.swift.org/swift-book)
- [iOS App Development](https://developer.apple.com/ios/)
- [Combine Framework](https://developer.apple.com/documentation/combine)

## 🎓 Learning Path

If you're new to iOS development:

1. Learn Swift basics
2. Understand SwiftUI fundamentals
3. Study MVVM architecture
4. Practice with small projects
5. Build this casino game
6. Extend with backend
7. Deploy to App Store

## 🎉 Acknowledgments

Thanks to:
- The Swift community
- Apple for SwiftUI
- Open-source contributors

---

**Made with ❤️ by Marcos Sabate**

If you found this helpful, please ⭐ the repository!
