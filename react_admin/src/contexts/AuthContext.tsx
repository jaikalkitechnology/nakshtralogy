import React, { createContext, useContext, useState, useEffect, ReactNode } from "react";
import { loginAdmin, logoutUser, getStoredUser } from "@/services/api";

export type UserRole = "admin";

interface AuthUser {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  avatar?: string;
  walletBalance: number;
  // null = unrestricted ("Super Admin"). See react_admin's Role Permissions page.
  permissions: string[] | null;
  allowedPages: string[] | null;
}

interface AuthContextType {
  user: AuthUser | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<{ error: string | null; redirectTo: string }>;
  logout: () => void;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | null>(null);

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be within AuthProvider");
  return ctx;
};

function mapUser(data: any): AuthUser {
  return {
    id: data.id,
    name: data.name || "",
    email: data.email,
    role: "admin",
    avatar: data.avatar_url,
    walletBalance: data.wallet_balance || 0,
    permissions: data.permissions ?? null,
    allowedPages: data.allowed_pages ?? null,
  };
}

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<AuthUser | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const stored = getStoredUser();
    // Only restore admin sessions — this panel is admin-only.
    if (stored && stored.role === "admin") {
      setUser(mapUser(stored));
    } else if (stored) {
      logoutUser();
    }
    setLoading(false);
  }, []);

  const login = async (email: string, password: string) => {
    const { ok, data } = await loginAdmin(email, password);
    if (ok && data.user) {
      if (data.user.role !== "admin") {
        logoutUser();
        return { error: "This account is not an administrator.", redirectTo: "" };
      }
      setUser(mapUser(data.user));
      return { error: null, redirectTo: "/admin" };
    }
    return { error: data.detail || "Login failed", redirectTo: "" };
  };

  const logout = () => {
    logoutUser();
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, loading, login, logout, isAuthenticated: !!user }}>
      {children}
    </AuthContext.Provider>
  );
};
