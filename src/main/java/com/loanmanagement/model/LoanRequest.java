package com.loanmanagement.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class LoanRequest {

    private Long id;
    private String nombreSolicitante;
    private BigDecimal importeSolicitado;
    private String divisa;
    private String documentoIdentificativo;
    private LocalDateTime fechaCreacion;
    private LoanStatus estado;

    public LoanRequest() {
    }

    public LoanRequest(Long id, String nombreSolicitante, BigDecimal importeSolicitado,
            String divisa, String documentoIdentificativo,
            LocalDateTime fechaCreacion, LoanStatus estado) {
        this.id = id;
        this.nombreSolicitante = nombreSolicitante;
        this.importeSolicitado = importeSolicitado;
        this.divisa = divisa;
        this.documentoIdentificativo = documentoIdentificativo;
        this.fechaCreacion = fechaCreacion;
        this.estado = estado;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public LoanStatus getEstado() {
        return estado;
    }

    public void setEstado(LoanStatus estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return "LoanRequest{" +
                "id=" + id +
                ", nombreSolicitante='" + nombreSolicitante + '\'' +
                ", importeSolicitado=" + importeSolicitado +
                ", divisa='" + divisa + '\'' +
                ", documentoIdentificativo='" + documentoIdentificativo + '\'' +
                ", fechaCreacion=" + fechaCreacion +
                ", estado=" + estado +
                '}';
    }
}
