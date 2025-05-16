# Ory - AI-Powered Personal Assistant App

Ory is a versatile Flutter application that leverages Google's Gemini AI to provide intelligent solutions for everyday needs. The app offers multiple AI-powered services including smart scheduling, prescription analysis, personalized recommendations, and budget planning.

## Features

- **Smart Schedule Optimization**: AI-powered calendar management that helps you organize your day efficiently and gain more free time
- **Prescription Analysis**: Upload prescription images to get detailed analysis and medication recommendations
- **AI-Powered Budget Planning**: Create personalized budget plans based on your income, expenses, and financial goals
- **Deal Recommendations**: Get personalized AI-powered recommendations and exclusive offers

## Prerequisites

- Flutter SDK (version ^3.7.0)
- Dart SDK
- A Gemini API key from Google AI Studio
- Android Studio/VS Code

## Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/MotiurRahmanSany/ory_app.git
   cd ory_app
   ```

2. Get dependencies:

   ```bash
   flutter pub get
   ```

3. Create a `.env` file in the root directory with your Gemini API key:

   ```
   GEMINI_API_KEY=your_api_key_here
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Getting a Gemini API Key

1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with your Google account
3. Click on "Get API key" or "Create API key"
4. Copy the generated API key
5. Add it to your `.env` file as shown in the installation instructions

## Tech Stack

- **Flutter**: UI framework
- **Riverpod**: State management
- **Google Generative AI**: For AI capabilities via Gemini
- **Flutter DotEnv**: Environment variable management
- **Dio**: HTTP client
- **Image Picker & Image Compression**: For handling prescription images
- **Table Calendar**: For scheduling features
- **FL Chart**: For budget visualization
- **Carousel Slider**: For UI elements

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

### Enjoyed Ory?

If you found this project helpful or interesting, please consider giving it a star on GitHub! ⭐
Your support helps make this project more visible to other developers and encourages further development.

```
🌟 Star this repository if you found it useful! 🌟
```
