[bits 32]

msg_sm: db "FAILED - Must have only one state after the barrier", 0
msg_ok: db "SUCCESS", 0

s2e_sm_test:
    call s2e_sm_fork

    call s2e_sm_succeed

    ;At this point, there can be only one state
    call s2e_sm_get_state_count
    cmp eax, 1
    je sst1

    ;We must have only one state at this point
    push msg_sm
    push eax
    call s2e_kill_state

sst1:

    ;Finish the test
    push msg_ok
    push 0
    call s2e_kill_state
    add esp, 8
    ret


;Fork lots of states
s2e_sm_fork:
    push ebp
    mov ebp, esp
    sub esp, 4

    call s2e_fork_enable

    mov dword [ebp - 4], 4  ; Set forking depth to 4 (2^^4 states)
ssf1:
    call s2e_int
    cmp eax, 0
    ja ssf2
ssf2:
    dec dword [ebp - 4]; Decrement forking depth
    jnz ssf1

    leave
    ret

