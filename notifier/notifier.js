function main(data) {
    if(data.status == 'new') {
      console.log("Send slack notification for new question: " + data.question.question_id+ " (tagged: " + data.question.tags + ")");
      return {payload: "Notified"};
    } else {
      return {payload: "Comnplete"};
    }
    
}
