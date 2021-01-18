

class StripeTransactionResponse{
  String message;
  bool succes;
  StripeTransactionResponse({this.message,this.succes});

}

class StripeService{
  static String apiBase = 'https://api.stripe.com//v1';
  static String secret = '';

  static init(){

  }

  static payViaExistingCard({String amount,String currency, card}){
    return new StripeTransactionResponse(
      message: 'Transacion realiza',
      succes: true
    );

  }



}