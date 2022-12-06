pragma circom 2.0.2;

// include "../../circuits/ecdsa.circom";
include "../../circuits/bigint.circom";
include "../../circuits/secp256k1_func.circom";
include "../../circuits/secp256k1.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";

template ECDSACheckPubKey(n, k) {
    assert(n == 64 && k == 4);
    signal input pubkey[2][k];

    // component point_on_curve = Secp256k1PointOnCurve();
    // for (var i = 0; i < 4; i++) {
    //     point_on_curve.x[i] <== pubkey[0][i];
    //     point_on_curve.y[i] <== pubkey[1][i];
    // }

    var order_minus_one[100] = get_secp256k1_order(n, k);
    order_minus_one[0]--;
    
    component lhs = Secp256k1ScalarMult(n, k);
    for (var i = 0; i < k; i++) {
        lhs.scalar[i] <== order_minus_one[i];
    }
    for (var i = 0; i < k; i++) {
        lhs.point[0][i] <== pubkey[0][i];
        lhs.point[1][i] <== pubkey[1][i];
    }

    for (var i = 0; i < k; i++) {
        lhs.out[0][i] === pubkey[0][i];
    }

    // var prime[100] = get_secp256k1_prime(n, k);
    // component negative_y = BigSub(n, k);
    // for (var i = 0; i < k; i++) {
    //     negative_y.a[i] <== prime[i];
    //     negative_y.b[i] <== pubkey[1][i];
    // }
    // negative_y.underflow === 0;

    // for (var i = 0; i < k; i++) {
    //     lhs.out[1][i] === negative_y.out[i];
    // }
}

component main {public [pubkey]} = ECDSACheckPubKey(64, 4);
