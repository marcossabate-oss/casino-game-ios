import Foundation
import AVFoundation

class SoundService: NSObject, ObservableObject {
    static let shared = SoundService()
    
    var audioPlayer: AVAudioPlayer?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .default, options: [])
        try? audioSession.setActive(true)
    }
    
    // MARK: - Sound Effects
    func playWinSound() {
        playSystemSound(SoundType.win.filename)
    }
    
    func playLoseSound() {
        playSystemSound(SoundType.lose.filename)
    }
    
    func playSpinSound() {
        playSystemSound(SoundType.spin.filename)
    }
    
    func playClickSound() {
        playSystemSound(SoundType.click.filename)
    }
    
    func playChipsSound() {
        playSystemSound(SoundType.chips.filename)
    }
    
    func playDealSound() {
        playSystemSound(SoundType.deal.filename)
    }
    
    func playBetSound() {
        playSystemSound(SoundType.bet.filename)
    }
    
    func playJackpotSound() {
        playSystemSound(SoundType.jackpot.filename)
    }
    
    private func playSystemSound(_ filename: String) {
        if let soundURL = Bundle.main.url(forResource: filename, withExtension: "mp3") {
            try? audioPlayer = AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        }
    }
    
    // Fallback to system sounds
    func playNotificationSound() {
        AudioServicesPlaySystemSound(1333) // Bell
    }
    
    func playAlertSound() {
        AudioServicesPlaySystemSound(1000) // Vibration
    }
    
    // MARK: - Music
    var backgroundMusicPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        if let musicURL = Bundle.main.url(forResource: "casino_background", withExtension: "mp3") {
            try? backgroundMusicPlayer = AVAudioPlayer(contentsOf: musicURL)
            backgroundMusicPlayer?.numberOfLoops = -1 // Loop infinitely
            backgroundMusicPlayer?.volume = 0.3
            backgroundMusicPlayer?.play()
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
    
    func setMusicVolume(_ volume: Float) {
        backgroundMusicPlayer?.volume = volume
    }
    
    // MARK: - Vibration
    func vibrate() {
        AudioServicesPlaySystemSoundWithCompletion(1520) { }
    }
    
    func vibrateLight() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func vibrateMedium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func vibrateHeavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    enum SoundType {
        case win, lose, spin, click, chips, deal, bet, jackpot
        
        var filename: String {
            switch self {
            case .win:
                return "win"
            case .lose:
                return "lose"
            case .spin:
                return "spin"
            case .click:
                return "click"
            case .chips:
                return "chips"
            case .deal:
                return "deal"
            case .bet:
                return "bet"
            case .jackpot:
                return "jackpot"
            }
        }
    }
}
