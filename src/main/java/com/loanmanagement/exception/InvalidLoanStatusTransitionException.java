package com.loanmanagement.exception;

// Excepción lanzada cuando se intenta una transición de estado inválida

public class InvalidLoanStatusTransitionException extends RuntimeException {

    public InvalidLoanStatusTransitionException(String message) {
        super(message);
    }

    public InvalidLoanStatusTransitionException(String message, Throwable cause) {
        super(message, cause);
    }
}
