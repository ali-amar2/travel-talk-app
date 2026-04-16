String mapFirebaseAuthError(String code) {
  switch (code) {
    case 'email-already-in-use':
      return 'This email is already in use.';
    case 'invalid-email':
      return 'Please enter a valid email.';
    case 'weak-password':
      return 'Password is too weak.';
    case 'user-not-found':
      return 'No user found for this email.';
    case 'wrong-password':
    case 'invalid-credential':
      return 'Incorrect email or password.';
    case 'network-request-failed':
      return 'Please check your internet connection.';
    case 'too-many-requests':
      return 'Too many attempts. Please try again later.';
    default:
      return 'Something went wrong. Please try again.';
  }
}
