# Contract address: 0x0179ada86c0879f1a1d2985953ddce0999883458983af1a72315beb0588112f3

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_nn

@contract_interface
namespace IBalanceContract:
    func increase_balance(amount : felt):
    end

    func get_balance() -> (res : felt):
    end
end

@external
func call_increase_balance{syscall_ptr : felt*, range_check_ptr}(
    contract_address : felt, amount : felt
):
    IBalanceContract.increase_balance(
        contract_address=contract_address, amount=amount
    )
    return ()
end

@view
func call_get_balance{syscall_ptr : felt*, range_check_ptr}(
    contract_address : felt
) -> (res : felt):
    let (res) = IBalanceContract.get_balance(
        contract_address=contract_address,
    )
    return (res=res)
end