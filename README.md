Voice Enabled Agentforce Assistant
Overview

This project implements a voice-enabled AI assistant inside Salesforce that allows users to interact with Agentforce using natural speech.
The system captures voice input from a Lightning Web Component (LWC), sends the request to Agentforce via Apex, and returns a response that is spoken back to the user.

The goal is to demonstrate how conversational AI can be integrated directly within Salesforce workflows.

Key Features
Voice input capture from Salesforce UI
Speech-to-text transcription in LWC
Apex callout to Agentforce ApiName
Invocable Agent Action to trigger Agentforce logic
AI-generated response returned to Salesforce
Text-to-speech output for spoken responses

Architecture

User Voice Input
↓
LWC (Speech Capture + Transcription)
↓
Apex Callout
↓
Agentforce API
↓
AI Response
↓
Speaker Output in LWC

Technology Stack
Salesforce Lightning Web Components (LWC)
Apex
Agentforce
Amazon Connect (for voice integration) optional


Setup Instructions
1. Clone the Repository
git clone <repository-url>
2. Authorize Salesforce Org
Login to your Salesforce org using the Salesforce CLI.
3. Deploy Metadata
Deploy the project metadata to your Salesforce org.
4. Configure Agentforce Agent
Create a Agent to use the AgentforceAPI with apex/LWC.
   

Open the Lightning page containing the Voice Assistant LWC

Speak your query
The system transcribes the voice input and sends it to Agentforce
The AI response is returned and spoken through the speaker

Use Cases

AI-powered CRM assistance
Voice-based data queries in Salesforce
Customer support automation
Hands-free interaction with enterprise systems

Future Enhancements

Multi-language voice recognition
Context-aware AI responses
Integration with Salesforce Service Cloud workflows
Real-time call automation using Amazon Connect
