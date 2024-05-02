

class SignUpEmailPasswordException{
  final String message;

  const SignUpEmailPasswordException([this.message="Un error c'est produit"]);

factory SignUpEmailPasswordException.code(String code){
  switch(code){
    case 'weak-password':
      return SignUpEmailPasswordException("Le mot de passe fourni est trop faible.");
    case 'email-already-in-use':
      return SignUpEmailPasswordException("Le compte existe déjà pour cet e-mail.");
    case 'invalid-email':
      return SignUpEmailPasswordException("L'adresse e-mail est invalide.");
    case 'user-not-found':
      return SignUpEmailPasswordException("Aucun utilisateur trouvé pour cet e-mail.");
    case 'wrong-password':
      return SignUpEmailPasswordException("Mot de passe incorrect pour cet utilisateur.");
    default:
      return SignUpEmailPasswordException("Une erreur s'est produite. Veuillez réessayer.");
  }
}

}