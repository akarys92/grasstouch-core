// let input = [7, 13, 17, 23]
let input = [1, 3, 5, 7]
let output = {}; 
let count = 0; 
for(let a = 0; a< 4; a++) {
    for(let b = 0; b< 4; b++) {
        for(let c = 0; c< 4; c++) {
            for(let d = 0; d< 4; d++) {
                let sum = input[a] + input[b] + input [c] + input[d]; 
                if(sum in Object.keys(output)) {
                    output[sum]++; 
                }
                else {
                    output[sum] = 1; 
                }
                count++; 
            }
        }
    }   
}

console.log(output)
console.log(count); 