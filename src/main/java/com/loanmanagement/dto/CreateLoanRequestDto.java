package com.loanmanagement.dto;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;
import java.math.BigDecimal;

public class CreateLoanRequestDto {

    @NotBlank(message = "El nombre del solicitante es obligatorio")
    private String nombreSolicitante;

    @NotNull(message = "El importe solicitado es obligatorio")
    @Positive(message = "El importe solicitado debe ser positivo")
    private BigDecimal importeSolicitado;

    @NotBlank(message = "La divisa es obligatoria")
    private String divisa;

    @NotBlank(message = "El documento de identificación es obligatorio")
    private String documentoIdentificativo;

    public CreateLoanRequestDto() {
    }

    public CreateLoanRequestDto(String nombreSolicitante, BigDecimal importeSolicitado,
            String divisa, String documentoIdentificativo) {
        this.nombreSolicitante = nombreSolicitante;
        this.importeSolicitado = importeSolicitado;
        this.divisa = divisa;
        this.documentoIdentificativo = documentoIdentificativo;
    }

    public String getNombreSolicitante() {
        return nombreSolicitante;
    }

    public void setNombreSolicitante(String nombreSolicitante) {
        this.nombreSolicitante = nombreSolicitante;
    }

    public BigDecimal getImporteSolicitado() {
        return importeSolicitado;
    }

    public void setImporteSolicitado(BigDecimal importeSolicitado) {
        this.importeSolicitado = importeSolicitado;
    }

    public String getDivisa() {
        return divisa;
    }

    public void setDivisa(String divisa) {
        this.divisa = divisa;
    }

    public String getDocumentoIdentificativo() {
        return documentoIdentificativo;
    }

    public void setDocumentoIdentificativo(String documentoIdentificativo) {
        this.documentoIdentificativo = documentoIdentificativo;
    }
}
