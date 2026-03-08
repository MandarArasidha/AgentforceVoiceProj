import { LightningElement, track } from 'lwc';
import invokeAgent from '@salesforce/apex/AgentFlowInvoker.invokeAgent';

export default class VoiceToAgent extends LightningElement {
    @track transcript = '';
    recognition;
    agentText;

    sessionId;
    agentResponse;

    agentApiName = 'Agentforce_Employee_Agent';

    //Click button to Send userInput
    sendToAgent() {


        const userText = this.transcript;
        if(!userText || userText.trim() === ''){
            const sampleReply = 'Hello, I am Agentforce assistant. No input was received.';
            this.agentText =  sampleReply;
            this.speakResponse(sampleReply);
            return;
        }

    invokeAgent({
        agentApiName: this.agentApiName,
        userMessage: userText,
        sessionId: this.sessionId
    })
     .then(result => {
        console.log('Agent result:', result);

        if (result.success) {
            this.agentResponse = result.text;
            this.sessionId = result.sessionId;

            // MOST IMPORTANT — speak the reply
            this.speakResponse(result.text);
        } else {
            this.agentResponse = result.text;
        }
    })
    .catch(error => {
        console.error(error);
    });
}
    connectedCallback() {

         //this.sessionId = sessionStorage.getItem('agentSession');

        const SpeechRecognition =
            window.SpeechRecognition || window.webkitSpeechRecognition;

        if (SpeechRecognition) {
            this.recognition = new SpeechRecognition();
            this.recognition.lang = 'en-IN';
            this.recognition.continuous = false;
            this.recognition.interimResults = false;

            this.recognition.onresult = (event) => {
                this.transcript = event.results[0][0].transcript;
            };

            this.recognition.onerror = (event) => {
                console.error('Speech error:', event.error);
            };
        } else {
            alert('Speech Recognition not supported in this browser.');
        }
    }

    startListening() {
        if (this.recognition) {
            this.recognition.start();
        }
    }

/*

    //Turn on voice as input
    sendToAgent() {
        // send transcript to Agentforce

        const userText = this.transcript;

        console.log('Sending to Agentforce:', userText);

        // Option 1: call Apex
        // Option 2: call Agentforce REST
        // Option 3: invoke Agent Action


        if(!userText || userText.trim() === ''){
            const sampleReply = 'Hello, I am Agentforce assistant, no input was recieved.';

        this.agentText = sampleReply;
        this.speakResponse(sampleReply);
        return;
        }
        */

        /*
         //  When real Agentforce is wired
        console.log('Sending to Agentforce:', userText);

        // TODO: replace with real agent call
        const dummyAgentReply =
        'I received your request and I am processing the order summary.';

        this.agentText = dummyAgentReply;
        this.speakResponse(dummyAgentReply);
        // Example placeholder:
        // callAgent({ message: userText })
        


    }
    */

    speakResponse(text) {
    if (!('speechSynthesis' in window)) {
        console.error('Text-to-Speech not supported');
        return;
    }

    const speak = () => {
        const utterance = new SpeechSynthesisUtterance(text);
        utterance.lang = 'en-IN';
        utterance.rate = 1;
        utterance.pitch = 1;

        window.speechSynthesis.cancel();
        window.speechSynthesis.speak(utterance);
    };

    // important fix
    if (speechSynthesis.getVoices().length === 0) {
        speechSynthesis.onvoiceschanged = speak;
    } else {
        speak();
    }
}
}