package com.loanmanagement.controller;

import com.loanmanagement.dto.CreateLoanRequestDto;
import com.loanmanagement.dto.LoanResponseDto;
import com.loanmanagement.dto.UpdateLoanStatusDto;
import com.loanmanagement.model.LoanRequest;
import com.loanmanagement.service.LoanService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.Collection;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/loans")
public class LoanController {

    private final LoanService loanService;

    public LoanController(LoanService loanService) {
        this.loanService = loanService;
    }

    @PostMapping
    public ResponseEntity<LoanResponseDto> createLoan(@Valid @RequestBody CreateLoanRequestDto createDto) {
        LoanRequest createdLoan = loanService.createLoan(createDto);
        LoanResponseDto responseDto = convertToResponseDto(createdLoan);
        return new ResponseEntity<>(responseDto, HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<Collection<LoanResponseDto>> getAllLoans() {
        Collection<LoanRequest> loans = loanService.getAllLoans();
        Collection<LoanResponseDto> responseDtos = loans.stream()
                .map(this::convertToResponseDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responseDtos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<LoanResponseDto> getLoanById(@PathVariable Long id) {
        LoanRequest loan = loanService.getLoanById(id);
        LoanResponseDto responseDto = convertToResponseDto(loan);
        return ResponseEntity.ok(responseDto);
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<LoanResponseDto> updateLoanStatus(
            @PathVariable Long id,
            @Valid @RequestBody UpdateLoanStatusDto updateDto) {
        LoanRequest updatedLoan = loanService.updateLoanStatus(id, updateDto.getStatus());
        LoanResponseDto responseDto = convertToResponseDto(updatedLoan);
        return ResponseEntity.ok(responseDto);
    }

    private LoanResponseDto convertToResponseDto(LoanRequest loan) {
        return new LoanResponseDto(
                loan.getId(),
                loan.getNombreSolicitante(),
                loan.getImporteSolicitado(),
                loan.getDivisa(),
                loan.getDocumentoIdentificativo(),
                loan.getFechaCreacion(),
                loan.getEstado());
    }
}