
void setup(){
    Serial.begin(9600);
}

void loop(){
    int i;
    for(i = 0;i<5;i++){
        Serial.println("Displaying message!");
    }
    exit(0);
}