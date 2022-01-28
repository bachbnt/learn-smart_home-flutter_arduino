#include "ESP8266WiFi.h"
#include "FirebaseESP8266.h"

const char* host = "https://smarthome-196c2.firebaseio.com";
const char* auth = "o8yec16lnRbvJkHXoTBQYvwyiqWrzWerDQIRxCEk";
const char* ssid = "DEVBLOCK";
const char* password = "DevBlocker@2019";

const char* path1 = "/Room/Livingroom/Devices/Light1/Status";
const char* path2 = "/Room/Livingroom/Devices/Television1/Status";
FirebaseData firebaseData;

int ledPin1 = 16;
int ledPin2 = 15;

void setup() {
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print("*");
  }
  Serial.print("WiFi connection successful");
  Serial.print("The IP Address is ");
  Serial.print(WiFi.localIP());
  Firebase.begin(host, auth);
}

void loop() {
  if (Firebase.getString(firebaseData, path1)) {
    if (firebaseData.dataType() == "string") {
      Serial.print("LED Status: ");
      Serial.print(firebaseData.stringData());
      Serial.print("");
      if (firebaseData.stringData() == "OFF") {
        digitalWrite(ledPin1, HIGH);
      } else {
        digitalWrite(ledPin1, LOW);
      }
    }
  }
  if (Firebase.getString(firebaseData, path2)) {
    if (firebaseData.dataType() == "string") {
      Serial.print("LED Status: ");
      Serial.print(firebaseData.stringData());
      Serial.print("");
      if (firebaseData.stringData() == "OFF") {
        digitalWrite(ledPin2, HIGH);
      } else {
        digitalWrite(ledPin2, LOW);
      }
    }
  }
}
