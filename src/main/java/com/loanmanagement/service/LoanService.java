package com.loanmanagement.service;

import com.loanmanagement.dto.CreateLoanRequestDto;
import com.loanmanagement.exception.InvalidLoanStatusTransitionException;
import com.loanmanagement.exception.LoanNotFoundException;
import com.loanmanagement.model.LoanRequest;
import com.loanmanagement.model.LoanStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

@Service
public class LoanService {

    private final Map<Long, LoanRequest> store = new ConcurrentHashMap<>();
    private final AtomicLong idGenerator = new AtomicLong(1);

    public LoanRequest createLoan(CreateLoanRequestDto dto) {
        Long newId = idGenerator.getAndIncrement();

        LoanRequest loanRequest = new LoanRequest(
                newId,
                dto.getNombreSolicitante(),
                dto.getImporteSolicitado(),
                dto.getDivisa(),
                dto.getDocumentoIdentificativo(),
                LocalDateTime.now(),
                LoanStatus.PENDIENTE);

        store.put(newId, loanRequest);
        return loanRequest;
    }

    public Collection<LoanRequest> getAllLoans() {
        return new ArrayList<>(store.values());
    }

    public LoanRequest getLoanById(Long id) {
        LoanRequest loan = store.get(id);
        if (loan == null) {
            throw new LoanNotFoundException("Solicitud de préstamo con ID " + id + " no encontrada");
        }
        return loan;
    }

    public LoanRequest updateLoanStatus(Long id, LoanStatus newStatus) {
        LoanRequest loan = getLoanById(id);
        LoanStatus currentStatus = loan.getEstado();

        if (!isValidTransition(currentStatus, newStatus)) {
            throw new InvalidLoanStatusTransitionException(
                    "Transición no permitida: de " + currentStatus + " a " + newStatus);
        }

        loan.setEstado(newStatus);
        store.put(id, loan);
        return loan;
    }

    private boolean isValidTransition(LoanStatus fromStatus, LoanStatus toStatus) {
        switch (fromStatus) {
            case PENDIENTE:
                return toStatus == LoanStatus.APROBADA || toStatus == LoanStatus.RECHAZADA;
            case APROBADA:
                return toStatus == LoanStatus.CANCELADA;
            case RECHAZADA:
            case CANCELADA:
                return false;
            default:
                return false;
        }
    }
}