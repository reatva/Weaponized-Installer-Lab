#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void rc4(unsigned char *data, int len, const char *key, int keylen) {
    unsigned char S[256];
    int i, j = 0, t;
    for(i = 0; i < 256; i++) S[i] = i;
    for(i = 0; i < 256; i++) {
        j = (j + S[i] + key[i % keylen]) & 0xFF;
        t = S[i]; S[i] = S[j]; S[j] = t;
    }
    i = j = 0;
    for(int x = 0; x < len; x++) {
        i = (i + 1) & 0xFF;
        j = (j + S[i]) & 0xFF;
        t = S[i]; S[i] = S[j]; S[j] = t;
        data[x] ^= S[(S[i] + S[j]) & 0xFF];
    }
}

int main() {
    const char *key = "secretkey";
    FILE *in = fopen("shellcode.bin", "rb");
    FILE *out = fopen("shellcode.enc", "wb");

    fseek(in, 0, SEEK_END);
    int len = ftell(in);
    rewind(in);

    unsigned char *data = malloc(len);
    fread(data, 1, len, in);
    rc4(data, len, key, strlen(key));
    fwrite(data, 1, len, out);

    fclose(in);
    fclose(out);
    free(data);

    printf("Encrypted shellcode.bin to shellcode.enc\n");
    return 0;
}
