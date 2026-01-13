package com.loanmanagement.exception;

// Excepción lanzada cuando no se encuentra una solicitud de préstamo

public class LoanNotFoundException extends RuntimeException {

    public LoanNotFoundException(String message) {
        super(message);
    }

    public LoanNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}
