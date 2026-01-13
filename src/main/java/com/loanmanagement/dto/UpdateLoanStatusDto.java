package com.loanmanagement.dto;

import com.loanmanagement.model.LoanStatus;

import javax.validation.constraints.NotNull;

public class UpdateLoanStatusDto {

    @NotNull(message = "El estado es obligatorio")
    private LoanStatus status;

    public UpdateLoanStatusDto() {
    }

    public UpdateLoanStatusDto(LoanStatus status) {
        this.status = status;
    }

    public LoanStatus getStatus() {
        return status;
    }

    public void setStatus(LoanStatus status) {
        this.status = status;
    }
}
