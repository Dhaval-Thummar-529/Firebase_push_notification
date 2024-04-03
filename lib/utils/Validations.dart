class Validations {
  bool emailValidator(String email) {
    RegExp emailRegex = RegExp(r"^[a-zA-Z\d.]+@[a-zA-Z\d]+\.[a-zA-Z]+");
    if (emailRegex.hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }

  bool phoneValidator(String phone) {
    RegExp phoneRegex = RegExp(r"^\d{10}$");
    if (phoneRegex.hasMatch(phone)) {
      return true;
    } else {
      return false;
    }
  }

  bool nameValidator(String name) {
    RegExp nameRegex = RegExp(r"^[a-zA-Z]*$");
    if (nameRegex.hasMatch(name)) {
      return true;
    } else {
      return false;
    }
  }

  bool companyNameValidator(String name) {
    RegExp companyName = RegExp(r"^[a-zA-Z\d- @.#&!]*$");
    if (companyName.hasMatch(name)) {
      return true;
    } else {
      return false;
    }
  }

  bool addressValidator(String address) {
    RegExp addressRegex = RegExp(r"^[A-Za-z\d'.\-\s,]*$");
    if (addressRegex.hasMatch(address)) {
      return true;
    } else {
      return false;
    }
  }

  bool pinCodeValidator(String pinCode) {
    RegExp pinCodeRegex = RegExp(r"^[1-9]{1}\d{2}\\s{0, 1}\d{3}$");
    if (pinCodeRegex.hasMatch(pinCode)) {
      return true;
    } else {
      return false;
    }
  }

  bool aadharNumberValidator(String aadhar){
    RegExp aadharRegex = RegExp(r"^[2-9]{1}\d{3}\d{4}\d{4}$");
    if(aadharRegex.hasMatch(aadhar)){
      return true;
    }else{
      return false;
    }
  }

  bool panNumberValidator(String pan){
    RegExp panRegex = RegExp(r"^[A-Z]{5}\d{4}[A-Z]$");
    if(panRegex.hasMatch(pan)){
      return true;
    }
    else{
      return false;
    }
  }
  
  bool upiIdValidator(String upiId){
    RegExp upiRegex = RegExp(r"^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$");
    if(upiRegex.hasMatch(upiId)){
      return true;
    }else{
      return false;
    }
  }
}
